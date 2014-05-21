from django.conf import settings


default_page_size = 20

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

def float_filter(value):
    """
    The float filter for wtforms.
    """
    try:
        return float(value)
    except:
        return 0.0

def int_filter(value):
    """
    The int filter for wtforms.
    """
    try:
        return int(value)
    except:
        return 0
