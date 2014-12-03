from django.template.response import TemplateResponse
from django.utils.cache import add_never_cache_headers
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
    response = TemplateResponse(request, 'base.html', {
        'url': url
    })
    add_never_cache_headers(response)
    return response
