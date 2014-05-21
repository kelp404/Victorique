import json
from application.exceptions import Http400
from application.responses import JsonResponse
from application.decorators import authorization
from application.models.datastore.user_model import UserPermission, UserModel
from application.forms.profile_form import ProfileForm


@authorization(UserPermission.root, UserPermission.normal)
def get_profile(request):
    return JsonResponse(request.user.dict())

@authorization(UserPermission.root, UserPermission.normal)
def update_profile(request):
    form = ProfileForm(**json.loads(request.body))
    if not form.validate():
        raise Http400

    user = UserModel.get_by_id(request.user.key().id())
    user.name = form.name.data
    user.put()
    return JsonResponse(user)
