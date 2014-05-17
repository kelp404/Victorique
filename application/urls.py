from django.conf.urls import patterns, url
from application.exceptions import *
from application.dispatches import api_dispatch, dispatch
from application.views.base import base_view
from application.views.settings import *
from application.views.applications import *


# error handlers
handler403 = permission_denied
handler404 = page_not_found
handler500 = server_error


# routers
urlpatterns = patterns('',
    url(r'^$', dispatch(GET=base_view)),

    # /applications
    url(r'^applications$', api_dispatch(
        GET=get_applications
    )),

    # /settings
    url(r'^settings$', api_dispatch(
        GET=get_settings,
    )),
    # /settings/profile
    url(r'^settings/profile$', api_dispatch(
        PUT=update_profile,
    )),
)
