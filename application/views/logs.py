import json, os
from datetime import datetime
from google.appengine.api import search, mail
from django.http.response import HttpResponse
from django.conf import settings
from application import utils
from application.exceptions import Http400, Http404, Http403
from application.responses import JsonResponse
from application.decorators import authorization
from application.forms.log_form import LogForm
from application.forms.search_form import SearchForm
from application.models.dto.page_list import PageList
from application.models.datastore.user_model import UserModel, UserPermission
from application.models.datastore.application_model import ApplicationModel
from application.models.datastore.log_model import LogModel


@authorization(UserPermission.root, UserPermission.normal)
def get_logs(request, application_id):
    application_id = long(application_id)
    form = SearchForm(**request.GET.dict())

    if application_id == 0:
        # fetch the first application
        if request.user.permission == UserPermission.root:
            applications = ApplicationModel.all().order('title').fetch(1)
        else:
            applications = ApplicationModel.gql('where member_ids in :1 order by title', [request.user.key().id()]).fetch(1)
        if len(applications):
            application = applications[0]
        else:
            # no applications
            return JsonResponse(PageList(0, 20, 0, []))
    else:
        application = ApplicationModel.get_by_id(application_id)
        if application is None:
            raise Http404
        if request.user.permission != UserPermission.root and\
                        request.user.key().id() not in application.member_ids:
            # no permission for this application
            raise Http403

    if form.keyword.data:
        source = [item for item in form.keyword.data.split(' ') if len(item) > 0]
        plus = [item for item in source if item.find('-') != 0]
        minus = [item[1:] for item in source if item.find('-') == 0 and len(item) > 1]

        if len(plus) > 0:
            keyword = ' '.join(plus)
            query_string = '(users:{1}) OR (title:{1}) OR (document:{1}) OR (user_agent:{1}) OR (ip:{1})'.replace('{1}', keyword)
        if len(minus) > 0:
            keyword = ' '.join(minus)
            query_string = 'NOT ((users:{1}) OR (title:{1}) OR (document:{1}) OR (user_agent:{1}) OR (ip:{1}))'.replace('{1}', keyword)
        update_time_desc = search.SortExpression(
            expression='update_time',
            direction=search.SortExpression.DESCENDING,
            default_value=0)
        options = search.QueryOptions(
            offset=utils.default_page_size * form.index.data,
            limit=utils.default_page_size,
            sort_options=search.SortOptions(expressions=[update_time_desc], limit=1000),
            returned_fields=['doc_id'])
        query = search.Query(query_string=query_string, options=options)
        search_result = search.Index(namespace='Logs', name=str(application.key().id())).search(query)
        total = search_result.number_found
        logs = LogModel.get_by_id([long(x.doc_id) for x in search_result])
    else:
        query = LogModel.all().filter('application =', application.key()).order('-update_time')
        total = query.count()
        logs = query.fetch(utils.default_page_size, form.index.data * utils.default_page_size)
    result = PageList(form.index.data, utils.default_page_size, total, logs).dict()
    result['application'] = {
        'id': application.key().id(),
        'title': application.title,
    }
    return JsonResponse(result)

@authorization(UserPermission.root, UserPermission.normal)
def get_log(request, application_id, log_id):
    log_id = long(log_id)
    log = LogModel.get_by_id(log_id)
    if log is None:
        raise Http404
    if request.user.permission != UserPermission.root and\
                    request.user.key().id() not in log.application.member_ids:
        # no permission for this application
        raise Http403
    return JsonResponse(log)

# GET /api/logs for jsonp
def add_log_jsonp(request, application_key):
    __add_log(request, application_key, request.GET.dict())
    return HttpResponse()
# POST /api/logs
def add_log(request, application_key):
    is_json = False
    for content_type in request.META['HTTP_CONTENT_TYPE'].split(','):
        if 'application/json' in content_type:
            is_json = True
            break
    if is_json:
        __add_log(request, application_key, json.loads(request.body))
    else:
        __add_log(request, application_key, request.POST.dict())
    return HttpResponse()

def __add_log(request, application_key, args):
    """
    Add the log.
    :param args: {dict} The log.
    :param is_jsonp: {bool}
    :return: The django response.
    """
    form = LogForm(key=application_key, **args)
    if not form.validate():
        raise Http400

    applications = ApplicationModel.all().filter('app_key =', form.key.data).fetch(1)
    if not len(applications):
        raise Http404
    application = applications[0]

    # Is the log exist?
    logs = LogModel.all().filter('title =', form.title.data)\
        .filter('application =', application.key()).fetch(1)
    if len(logs):
        # update log
        log = logs[0]
        log.count += 1
        log.update_time = datetime.utcnow()
        if not form.user.data is None and form.user.data not in log.users:
            log.users.append(form.user.data)
    else:
        # add the new log
        log = LogModel(
            application=application,
            title=form.title.data,
        )
        if not form.user.data is None:
            log.users = [form.user.data]
    if not form.document.data is None:
        log.document = form.document.data
    log.user_agent = request.META.get('HTTP_USER_AGENT')
    log.ip = os.environ.get('REMOTE_ADDR')
    log.put()
    if log.count == 1 and application.email_notification:
        # send email notification to members
        gae_account = getattr(settings, 'GAE_ACCOUNT')
        domain = getattr(settings, 'HOST')
        users = UserModel.get_by_id(application.member_ids)
        message = mail.EmailMessage(sender=gae_account, subject="%s has a new log at Victorique." % application.title)
        message.to = [x.email for x in users if not x is None]
        message.body = 'There is a new log at Victorique.\nhttps://%s/applications/%s/logs/%s' % (domain, application.key().id(), log.key().id())
        message.send()

    index = search.Index(namespace='Logs', name=str(application.key().id()))
    search_document = search.Document(doc_id=str(log.key().id()),
                                      fields=[
                                          search.TextField(name='users', value=str(log.users)),
                                          search.TextField(name='title', value=log.title),
                                          search.TextField(name='document', value=log.document_json),
                                          search.TextField(name='ip', value=log.ip),
                                          search.TextField(name='user_agent', value=log.user_agent),
                                          search.DateField(name='update_time', value=log.update_time)])
    index.put(search_document)
