import json
from google.appengine.ext import db
from application import utils
from application.models.datastore.base_model import BaseModel
from application.models.datastore.application_model import ApplicationModel


class LogModel(BaseModel):
    application = db.ReferenceProperty(reference_class=ApplicationModel, required=True)
    title = db.StringProperty(required=True, indexed=False)
    users = db.StringListProperty(default=[], indexed=False)
    count = db.IntegerProperty(default=1, indexed=False)
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
            'count': self.count,
            'document': self.document,
            'update_time': utils.get_iso_format(self.update_time),
            'create_time': utils.get_iso_format(self.create_time),
        }
