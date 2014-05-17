import unittest
from mock import MagicMock
from application.exceptions import Http403
from application.decorators import authorization
from application.models.datastore.user_model import UserPermission


class TestDecorators(unittest.TestCase):
    def setUp(self):
        self.request = MagicMock()

    def test_decorators_authorization_user_is_none_raise(self):
        self.request.user = None
        @authorization(UserPermission.root)
        def func(request):
            return 'done'
        self.assertRaises(Http403, func, self.request)

    def test_decorators_authorization_user_is_root(self):
        self.request.user.permission = UserPermission.root
        @authorization()
        def func(request):
            return 'done'
        result = func(self.request)
        self.assertEqual(result, 'done')

    def test_decorators_authorization_user_is_normal(self):
        self.request.user.permission = UserPermission.normal
        @authorization(UserPermission.normal)
        def func(request):
            return 'done'
        result = func(self.request)
        self.assertEqual(result, 'done')

    def test_decorators_authorization_user_is_normal_raise(self):
        self.request.user.permission = UserPermission.normal
        @authorization(UserPermission.root)
        def func(request):
            return 'done'
        self.assertRaises(Http403, func, self.request)
