import threading
from application.models.datastore.user_model import UserModel


g = threading.local()

class AuthenticationMiddleware(object):
    def process_request(self, request):
        request.user = UserModel.authorization()

class GlobalMiddleware(object):
    def process_request(self, request):
        # g.request = request
        pass
