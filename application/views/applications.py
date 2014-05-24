import json
from django.http.response import HttpResponse
from application import utils
from application.exceptions import Http400, Http404
from application.responses import JsonResponse
from application.decorators import authorization
from application.forms.search_form import SearchForm
from application.forms.application_form import ApplicationForm
from application.models.dto.page_list import PageList
from application.models.datastore.user_model import UserPermission
from application.models.datastore.application_model import ApplicationModel


@authorization(UserPermission.root, UserPermission.normal)
def get_applications(request):
    form = SearchForm(**request.GET.dict())
    total = ApplicationModel.all().count()
    applications = ApplicationModel.all().order('title')\
        .fetch(utils.default_page_size, form.index.data * utils.default_page_size)
    result = PageList(form.index.data, utils.default_page_size, total, applications)
    return JsonResponse(result)

@authorization(UserPermission.root, UserPermission.normal)
def get_application(request, application_id):
    application = ApplicationModel.get_by_id(long(application_id))
    if application is None:
        raise Http404
    return JsonResponse(application)

@authorization(UserPermission.root, UserPermission.normal)
def add_application(request):
    form = ApplicationForm(**json.loads(request.body))
    if not form.validate():
        raise Http400

    application = ApplicationModel()
    application.title = form.title.data
    application.description = form.description.data
    application.roots = [request.user.key().id()]
    application.put()
    return JsonResponse(application)

@authorization(UserPermission.root, UserPermission.normal)
def update_application(request, application_id):
    form = ApplicationForm(**json.loads(request.body))
    if not form.validate():
        raise Http400

    application = ApplicationModel.get_by_id(long(application_id))
    if application is None:
        raise Http404
    application.title = form.title.data
    application.description = form.description.data
    application.put()
    return JsonResponse(application)

@authorization(UserPermission.root, UserPermission.normal)
def delete_application(request, application_id):
    application = ApplicationModel.get_by_id(long(application_id))
    application.delete()
    return HttpResponse()
