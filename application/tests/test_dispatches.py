import unittest
from mock import MagicMock, patch
from application.tests import patcher
from application.exceptions import Http404
from application.dispatches import dispatch, api_dispatch


class TestDispatches(unittest.TestCase):
    def setUp(self):
        self.request = MagicMock()
        self.view = MagicMock(return_value='view')
        def raise_404(request):
            raise Http404
        self.view_404 = raise_404

    def test_dispatches_dispatch_get_success(self):
        self.request.method = 'GET'
        d = dispatch(
            GET=self.view,
        )
        response = d(self.request)
        self.view.assert_called_with(self.request)
        self.assertEqual(response, 'view')

    def test_dispatches_dispatch_get_method_not_allowed(self):
        self.request.method = 'GET'
        d = dispatch(
            POST=self.view,
        )
        response = d(self.request)
        self.assertEqual(response.status_code, 405)

    def test_dispatches_dispatch_raise_404(self):
        self.request.method = 'GET'
        d = dispatch(
            GET=self.view_404
        )
        response = d(self.request)
        self.assertEqual(response.status_code, 404)

    @patcher(
        patch('application.dispatches.base_view', new=MagicMock(return_value='base_view')),
    )
    def test_dispatches_api_dispatch_accept_not_json(self):
        self.request.method = 'GET'
        self.request.META = {
            'HTTP_ACCEPT': 'text/html'
        }
        d = api_dispatch(
            GET=self.view
        )
        response = d(self.request)
        self.assertEqual(response, 'base_view')
