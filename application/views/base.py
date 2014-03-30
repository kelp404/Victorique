from django.template.response import TemplateResponse
from google.appengine.api import users


def base_view(request):
    if request.user.is_login:
        url = {
            'logout': users.create_logout_url('/')
        }
    else:
        url = {
            'login': users.create_login_url()
        }
    return TemplateResponse(request, 'base.html', {
        'url': url
    })
