from wtforms import Form, StringField, validators


class ProfileForm(Form):
    """
    The form for update the profile.
    """
    name = StringField(
        validators=[validators.required()],
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None],
    )
