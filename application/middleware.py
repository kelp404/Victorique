from application.models.datastore.user_model import UserModel


class AuthenticationMiddleware(object):
    def process_request(self, request):
        request.user = UserModel.authorization()
