from django.conf import settings


def is_debug():
    """
    Is debug mode?
    :return: True / False
    """
    return getattr(settings, "DEBUG", True)
