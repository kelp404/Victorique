from application.views.error import bad_request, permission_denied,\
    page_not_found, method_not_allowed, server_error


class ApplicationException(Exception):
    def __init__(self, *args, **kwargs):
        super(ApplicationException, self).__init__(*args, **kwargs)
        self.view = server_error

class Http400(ApplicationException):
    def __init__(self, *args, **kwargs):
        super(ApplicationException, self).__init__(*args, **kwargs)
        self.view = bad_request

class Http403(ApplicationException):
    def __init__(self, *args, **kwargs):
        super(ApplicationException, self).__init__(*args, **kwargs)
        self.view = permission_denied

class Http404(ApplicationException):
    def __init__(self, *args, **kwargs):
        super(ApplicationException, self).__init__(*args, **kwargs)
        self.view = page_not_found

class Http405(ApplicationException):
    def __init__(self, *args, **kwargs):
        super(ApplicationException, self).__init__(*args, **kwargs)
        self.view = method_not_allowed

class Http500(ApplicationException):
    def __init__(self, *args, **kwargs):
        super(ApplicationException, self).__init__(*args, **kwargs)
        self.view = server_error