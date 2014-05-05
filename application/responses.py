import json
from django.http import HttpResponse


class JsonResponse(HttpResponse):
    """
    A response class for json result.
    """
    def __init__(self, content, *args, **kwargs):
        if 'dict' in dir(content) and callable(content.dict):
            dict_content = content.dict()
        else:
            dict_content = content
        super(JsonResponse, self).__init__(json.dumps(dict_content), content_type='application/json', *args, **kwargs)
