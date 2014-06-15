from wtforms import Form, StringField, BooleanField, validators
from application.forms import ArrayField


class ApplicationForm(Form):
    """
    The form for update the application.
    """
    title = StringField(
        validators=[validators.required()],
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None],
    )
    description = StringField(
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None],
    )
    app_key = BooleanField(
        default=False
    )
    member_ids = ArrayField()
    root_ids = ArrayField()
    email_notification = BooleanField(
        default=True
    )
