import unittest
from mock import MagicMock, patch
from application.tests import patcher
from application import context_processors


class TestContextProcessors(unittest.TestCase):
    @patcher(
        patch('application.utils.is_debug', new=MagicMock(return_value=True))
    )
    def test_context_processors_debug_true(self):
        context = context_processors.debug(None)
        self.assertDictEqual(context, {'debug': True})

    @patcher(
        patch('application.utils.is_debug', new=MagicMock(return_value=False))
    )
    def test_context_processors_debug_false(self):
        context = context_processors.debug(None)
        self.assertDictEqual(context, {'debug': False})
