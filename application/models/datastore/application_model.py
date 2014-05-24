from google.appengine.ext import db
from application import utils
from application.models.datastore.base_model import BaseModel


class ApplicationModel(BaseModel):
    title = db.StringProperty()
    description = db.TextProperty()
    app_key = db.StringProperty()
    roots = db.ListProperty(long, default=[])
    members = db.ListProperty(long, default=[])
    create_time = db.DateTimeProperty(auto_now_add=True)

    def dict(self):
        return {
            'id': self.key().id() if self.has_key() else None,
            'title': self.title,
            'description': self.description,
            'app_key': self.app_key,
            'roots': self.roots,
            'members': self.members,
            'create_time': utils.get_iso_format(self.create_time),
        }
