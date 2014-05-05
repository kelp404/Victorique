from django.conf.urls import patterns, url
from application.exceptions import *
from application.dispatches import api_dispatch, dispatch
from application.views.base import base_view
from application.views.settings import *


# error handlers
handler403 = permission_denied
handler404 = page_not_found
handler500 = server_error


# routers
urlpatterns = patterns('',
    url(r'^$', dispatch(GET=base_view)),
    url(r'^settings$', api_dispatch(
        GET=get_settings,
    )),
)
