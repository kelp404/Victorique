from wtforms import Form, StringField, BooleanField, validators


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
