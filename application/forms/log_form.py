from wtforms import Form, StringField, BooleanField, validators
from application.forms import DictField


class APILogForm(Form):
    """
    The form for adding a log.
    """
    key = StringField(
        validators=[validators.data_required()],
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None],
    )
    title = StringField(
        validators=[validators.data_required()],
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None],
    )
    user = StringField(
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None],
    )
    document = DictField()

class LogForm(Form):
    """
    The form for update the log.
    """
    is_close = BooleanField(
        default=False
    )
