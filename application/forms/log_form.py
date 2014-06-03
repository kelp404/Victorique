from wtforms import Form, StringField, validators
from application.forms import DictField


class LogForm(Form):
    """
    The form for update the log.
    """
    key = StringField(
        validators=[validators.required()],
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None],
    )
    title = StringField(
        validators=[validators.required()],
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None],
    )
    user = StringField(
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None],
    )
    document = DictField()
