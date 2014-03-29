import unittest
from mock import MagicMock, patch
from application import utils


class TestUtilsModels(unittest.TestCase):
    def test_utils_is_debug(self):
        self.patchers = [
            patch('django.conf.settings.DEBUG', new_callable=MagicMock(return_value='debug')),
        ]
        for patcher in self.patchers:
            patcher.start()

        is_debug = utils.is_debug()
        self.assertEqual(is_debug, 'debug')

        for patcher in self.patchers:
            patcher.stop()
