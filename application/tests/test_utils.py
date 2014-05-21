import unittest
from mock import MagicMock, patch
from application.tests import patcher
from application import utils


class TestUtilsModels(unittest.TestCase):
    @patcher(
        patch('django.conf.settings.DEBUG', new_callable=MagicMock(return_value='debug')),
    )
    def test_utils_is_debug(self):
        is_debug = utils.is_debug()
        self.assertEqual(is_debug, 'debug')

    def test_utils_get_iso_format(self):
        dt = MagicMock()
        dt.strftime.return_value = 'strftime'
        result = utils.get_iso_format(dt)
        dt.strftime.assert_called_with('%Y-%m-%dT%H:%M:%S.%fZ')
        self.assertEqual(result, 'strftime')

    def test_utils_float_filter(self):
        self.assertEqual(1.2, utils.float_filter(1.2))
        self.assertEqual(0.0, utils.float_filter(None))
        self.assertTrue(isinstance(utils.float_filter(None), float))
        self.assertEqual(0.0, utils.float_filter(''))
        self.assertTrue(isinstance(utils.float_filter(''), float))

    def test_utils_int_filter(self):
        self.assertEqual(1, utils.int_filter(1))
        self.assertEqual(0, utils.int_filter(None))
        self.assertTrue(isinstance(utils.int_filter(None), int))
        self.assertEqual(0, utils.int_filter(None))
        self.assertTrue(isinstance(utils.int_filter(''), int))
