import json, uuid
from django.http.response import HttpResponse
from application import utils
from application.exceptions import Http400, Http403, Http404
from application.responses import JsonResponse
from application.decorators import authorization
from application.forms.search_form import SearchForm
from application.forms.application_form import ApplicationForm
from application.forms.user_form import UserForm
from application.models.dto.page_list import PageList
from application.models.datastore.user_model import UserModel, UserPermission
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
    if request.user.permission != UserPermission.root and\
                    request.user.key().id() not in application.member_ids:
        raise Http403
    result = application.dict()
    result['members'] = [x.dict() for x in UserModel.get_by_id(application.member_ids) if not x is None]
    return JsonResponse(result)

@authorization(UserPermission.root, UserPermission.normal)
def add_application_member(request, application_id):
    form = UserForm(name='invite', **json.loads(request.body))
    if not form.validate():
        raise Http400
    application = ApplicationModel.get_by_id(long(application_id))
    if application is None:
        raise Http404
    if request.user.permission != UserPermission.root and\
                    request.user.key().id() not in application.root_ids:
        raise Http403
    user = UserModel.invite_user(request, form.email.data)
    application.member_ids.append(user.key().id())
    application.save()
    return JsonResponse(user)

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
        email_notification=form.email_notification.data,
        app_key=str(uuid.uuid1()),
    )
    application.put()
    return JsonResponse(application)

@authorization(UserPermission.root, UserPermission.normal)
def update_application(request, application_id):
    form = ApplicationForm(**json.loads(request.body))
    # if form.app_key.data is True -> update app key.
    if not form.app_key.data and not form.validate():
        raise Http400

    application = ApplicationModel.get_by_id(long(application_id))
    if application is None:
        raise Http404
    if request.user.permission != UserPermission.root and\
                    request.user.key().id() not in application.root_ids:
        raise Http403
    if form.app_key.data:
        application.app_key = str(uuid.uuid1())
    else:
        application.title = form.title.data
        application.description = form.description.data
        application.member_ids = form.member_ids.data
        application.root_ids = form.root_ids.data
        application.email_notification = form.email_notification.data
    application.put()
    return JsonResponse(application)

@authorization(UserPermission.root, UserPermission.normal)
def delete_application(request, application_id):
    application = ApplicationModel.get_by_id(long(application_id))
    if application is None:
        raise Http404
    if request.user.permission != UserPermission.root and\
                    request.user.key().id() not in application.root_ids:
        raise Http403
    application.delete()
    return HttpResponse()
