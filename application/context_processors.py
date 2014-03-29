from application import utils

def settings(context):
    return {
        'DEBUG': utils.is_debug()
    }
