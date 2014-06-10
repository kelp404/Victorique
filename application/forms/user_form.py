from wtforms import Form, StringField, IntegerField, validators
from application import utils
from application.models.datastore.user_model import UserPermission


class UserForm(Form):
    """
    The form for update the user.
    """
    name = StringField(
        validators=[validators.required()],
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None],
    )
    email = StringField(
        validators=[validators.email()],
        filters=[lambda x: x.strip().lower() if isinstance(x, basestring) else None],
    )
    permission = IntegerField(
        default=UserPermission.normal,
        validators=[validators.any_of([UserPermission.root, UserPermission.normal])],
        filters=[utils.int_filter],
    )
