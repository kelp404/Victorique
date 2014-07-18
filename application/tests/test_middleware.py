import unittest
from mock import MagicMock, patch
from application.tests import patcher
from application.middleware import *


class TestMiddleware(unittest.TestCase):
    def setUp(self):
        self.request = MagicMock()

    @patcher(
        patch('application.middleware.UserModel.authorization', new=MagicMock(return_value='auth'))
    )
    def test_middleware_authentication_middleware_process_request(self):
        middleware = AuthenticationMiddleware()
        middleware.process_request(self.request)
        UserModel.authorization.assert_called_with()
        self.assertEqual(self.request.user, 'auth')
