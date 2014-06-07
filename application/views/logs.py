import json
from datetime import datetime
from django.http.response import HttpResponse
from application import utils
from application.exceptions import Http400, Http404, Http403
from application.responses import JsonResponse
from application.decorators import authorization
from application.forms.log_form import LogForm
from application.forms.search_form import SearchForm
from application.models.dto.page_list import PageList
from application.models.datastore.user_model import UserPermission
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
        if request.user.permission != UserPermission.root and\
                        request.user.key().id() not in application.member_ids:
            # no permission for this application
            raise Http403

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
    __add_log(application_key, request.GET.dict())
    return HttpResponse()
# POST /api/logs
def add_log(request, application_key):
    is_json = False
    for content_type in request.META['HTTP_CONTENT_TYPE'].split(','):
        if 'application/json' in content_type:
            is_json = True
            break
    if is_json:
        __add_log(application_key, json.loads(request.body))
    else:
        __add_log(application_key, request.POST.dict())
    return HttpResponse()

def __add_log(application_key, args):
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
        if not form.document.data is None:
            log.document = form.document.data
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
    log.put()
