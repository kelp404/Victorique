import json, uuid
from django.http.response import HttpResponse
from application import utils
from application.exceptions import Http400, Http403, Http404
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
    if form.all.data:
        index = 0
        size = 1000
    else:
        index = form.index.data
        size = utils.default_page_size

    query = ApplicationModel.all().order('title')
    if request.user.permission != UserPermission.root:
        query = query.filter('member_ids in', [request.user.key().id()])
    total = query.count()
    applications = query.fetch(size, index * size)
    return JsonResponse(PageList(index, size, total, applications))

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

    application = ApplicationModel(
        title=form.title.data,
        description=form.description.data,
        root_ids=[request.user.key().id()],
        member_ids=[request.user.key().id()],
        app_key=str(uuid.uuid1()),
    )
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
    if request.user.key().id() not in application.root_ids:
        raise Http403
    application.title = form.title.data
    application.description = form.description.data
    application.put()
    return JsonResponse(application)

@authorization(UserPermission.root, UserPermission.normal)
def delete_application(request, application_id):
    application = ApplicationModel.get_by_id(long(application_id))
    if application is None:
        raise Http404
    if request.user.key().id() not in application.root_ids:
        raise Http403
    application.delete()
    return HttpResponse()
