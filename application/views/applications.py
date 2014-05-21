import json
from application.exceptions import Http400
from application.responses import JsonResponse
from application.decorators import authorization
from application.forms.application_form import ApplicationForm
from application.models.datastore.user_model import UserPermission
from application.models.datastore.application_model import ApplicationModel


@authorization(UserPermission.root, UserPermission.normal)
def get_applications(request):
    return JsonResponse({'success': True})

@authorization(UserPermission.root, UserPermission.normal)
def add_application(request):
    form = ApplicationForm(**json.loads(request.body))
    if not form.validate():
        raise Http400

    application = ApplicationModel()
    application.title = form.title.data
    application.description = form.description.data
    application.put()
    return JsonResponse(application)
