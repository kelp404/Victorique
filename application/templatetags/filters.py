import json
from django import template
from django.utils.html import mark_safe


register = template.Library()

@register.filter(name='json')
def get_json(object):
    """
    Get the json.
    :param object: The class instance.
    :return: 'json string'
    """
    if 'dict' in dir(object) and callable(object.dict):
        return mark_safe(json.dumps(object.dict()))
    elif isinstance(object, dict):
        return mark_safe(json.dumps(object))
    else:
        return mark_safe(json.dumps(object.__dict__))
