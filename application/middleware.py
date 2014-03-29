import threading


g = threading.local()

class AuthenticationMiddleware(object):
    def process_request(self, request):
        request.user = {}
        # acs = AccountService()
        # request.user = acs.authorization()

class GlobalMiddleware(object):
    def process_request(self, request):
        g.request = request
