from wtforms import Form, StringField, IntegerField, BooleanField
from application import utils


class SearchForm(Form):
    """
    The form for search.
    """
    keyword = StringField(
        filters=[lambda x: x.strip() if isinstance(x, basestring) else None]
    )
    index = IntegerField(
        filters=[utils.int_filter],
        default=0
    )
    all = BooleanField(
        default=False,
        filters=[lambda x: bool(x)],
    )
