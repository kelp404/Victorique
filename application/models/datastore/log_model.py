import json
from google.appengine.ext import db
from application import utils
from application.models.datastore.base_model import BaseModel
from application.models.datastore.application_model import ApplicationModel


class LogModel(BaseModel):
    application = db.ReferenceProperty(reference_class=ApplicationModel, required=True)
    title = db.StringProperty(required=True)
    users = db.StringListProperty(default=[], indexed=False)
    count = db.IntegerProperty(default=1, indexed=False)
    user_agent = db.StringProperty(indexed=False)
    ip = db.StringProperty(indexed=False)
    is_close = db.BooleanProperty(default=False)
    document_json = db.TextProperty()
    update_time = db.DateTimeProperty(auto_now_add=True)
    create_time = db.DateTimeProperty(auto_now_add=True)

    @property
    def document(self):
        if self.document_json is None:
            return None
        return json.loads(self.document_json)
    @document.setter
    def document(self, value):
        if not value is None:
            self.document_json = json.dumps(value)

    def dict(self):
        return {
            'id': self.key().id() if self.has_key() else None,
            'title': self.title,
            'users': self.users,
            'user_agent': self.user_agent,
            'ip': self.ip,
            'count': self.count,
            'is_close': self.is_close,
            'document': self.document,
            'update_time': utils.get_iso_format(self.update_time),
            'create_time': utils.get_iso_format(self.create_time),
        }
