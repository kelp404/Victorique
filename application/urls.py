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
    url(r'^login$', dispatch(GET=base_view)),

    # /applications
    url(r'^applications$', api_dispatch(
        GET=get_applications
    )),

    # /settings
    url(r'^settings$', dispatch(
        GET=base_view,
    )),
    # /settings/profile
    url(r'^settings/profile$', api_dispatch(
        GET=get_profile,
        PUT=update_profile,
    )),
    # /settings/applications
    url(r'^settings/applications$', api_dispatch(
        GET=get_applications,
        POST=add_application,
    )),
    # /settings/applications/new
    url(r'^settings/applications/new$', dispatch(
        GET=base_view,
    )),
)
