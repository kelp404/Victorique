from exceptions import Http403
from application.models.datastore.user_model import UserPermission


def authorization(*permissions):
    """
    Authorization decorator.
    :param level: UserPermission
    """
    def decorator(f):
        def wraps(request, *args, **kwargs):
            if not request.user:
                raise Http403

            # request.user is root
            if request.user.permission == UserPermission.root:
                return f(request, *args, **kwargs)

            if request.user.permission in permissions:
                return f(request, *args, **kwargs)
            else:
                raise Http403
        return wraps
    return decorator
