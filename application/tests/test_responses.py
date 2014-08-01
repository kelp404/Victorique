import unittest, json
from mock import MagicMock
from application.responses import JsonResponse


class TestResponses(unittest.TestCase):
    def test_responses_json_response_with_dict(self):
        result = {
            'user': 'kelp@phate.org'
        }
        response = JsonResponse(result)
        self.assertEqual(
            response._headers['content-type'],
            ('Content-Type', 'application/json'),
        )
        self.assertDictEqual(json.loads(response.content), result)

    def test_responses_json_response_with_object(self):
        result = MagicMock()
        result.dict.return_value = {
            'user': 'kelp@phate.org'
        }
        response = JsonResponse(result)
        self.assertEqual(
            response._headers['content-type'],
            ('Content-Type', 'application/json'),
        )
        self.assertDictEqual(json.loads(response.content), result.dict())
