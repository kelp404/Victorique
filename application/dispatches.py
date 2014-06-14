from application.exceptions import ApplicationException, method_not_allowed
from application.views.base import base_view


def dispatch(**dispatches):
    def wraps(request, *args, **kwargs):
        handler = dispatches.get(request.method, method_not_allowed)
        try:
            return handler(request, *args, **kwargs)
        except ApplicationException as e:
            return e.view(request)
    return wraps
def api_dispatch(**dispatches):
    def wraps(request, *args, **kwargs):
        if 'application/json' not in request.META['HTTP_ACCEPT'].split(','):
            # return base view for first loading
            return base_view(request)
        handler = dispatches.get(request.method, method_not_allowed)
        try:
            return handler(request, *args, **kwargs)
        except ApplicationException as e:
            return e.view(request)
    return wraps
