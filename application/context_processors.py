from application import utils

def debug(request):
    return {
        'debug': utils.is_debug()
    }
