import threading


g = threading.local()

class AuthenticationMiddleware(object):
    def process_request(self, request):
        from application.models.datastore.user_model import *
        request.user = UserModel()
        # acs = AccountService()
        # request.user = acs.authorization()

class GlobalMiddleware(object):
    def process_request(self, request):
        g.request = request
