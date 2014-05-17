from wtforms import Form, TextField, validators


class ProfileForm(Form):
    """
    The form for update profile.
    """
    name = TextField(
        validators=[validators.required()],
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None]
    )
