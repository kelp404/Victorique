from django.conf import settings


def is_debug():
    """
    Is debug mode?
    :return: True / False
    """
    return getattr(settings, "DEBUG", True)

def get_iso_format(date_time):
    """
    :param date_time: {datetime} The datetime.
    :return: The iso format datetime "yyyy-MM-ddTHH:mm:ss.ssssssZ"
    """
    return date_time.strftime('%Y-%m-%dT%H:%M:%S.%fZ')
