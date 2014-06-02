import json
from django.http.response import HttpResponse
from application import utils
from application.exceptions import Http400, Http404
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
        if not len(applications):
            return JsonResponse(PageList(0, 20, 0, []))
        else:
            application = applications[0]
    else:
        application = ApplicationModel.get_by_id(application_id)

    query = LogModel.all().filter('application =', application.key()).order('-update_time')
    total = query.count()
    logs = query.fetch(utils.default_page_size, form.index.data * utils.default_page_size)
    result = PageList(form.index.data, utils.default_page_size, total, logs).dict()
    result['application'] = {
        'id': application.key().id(),
        'title': application.title,
    }
    return JsonResponse(result)

# GET /api/logs for jsonp
def add_log_jsonp(request):
    __add_log(request.GET.dict(), True)
    return HttpResponse()
# POST /api/logs
def add_log(request):
    __add_log(request.POST.dict(), False)
    return HttpResponse()

def __add_log(args, is_jsonp):
    """
    Add the log.
    :param args: {dict} The log.
    :param is_jsonp: {bool}
    :return: The django response.
    """
    form = LogForm(**args)
    if not form.validate():
        raise Http400

    applications = ApplicationModel.all().filter('app_key =', form.key.data).fetch(1)
    if not len(applications):
        raise Http404
    application = applications[0]

    log = LogModel(
        application=application,
        title=form.title.data,
    )
    if not form.user.data is None:
        log.users = [form.user.data]
    if not form.data.data is None:
        log.data = json.loads(form.data.data)
    log.put()
