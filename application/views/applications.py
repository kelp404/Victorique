from application.responses import JsonResponse
from application.decorators import authorization
from application.models.datastore.user_model import UserPermission


@authorization(UserPermission.root, UserPermission.normal)
def get_applications(request):
    return JsonResponse({'success': True})
