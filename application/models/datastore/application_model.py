from google.appengine.ext import db
from application import utils
from application.models.datastore.base_model import BaseModel


class ApplicationModel(BaseModel):
    title = db.StringProperty(required=True)
    description = db.TextProperty()
    app_key = db.StringProperty()
    root_ids = db.ListProperty(long, default=[])
    member_ids = db.ListProperty(long, default=[])
    create_time = db.DateTimeProperty(auto_now_add=True)

    def dict(self):
        return {
            'id': self.key().id() if self.has_key() else None,
            'title': self.title,
            'description': self.description,
            'app_key': self.app_key,
            'root_ids': self.root_ids,
            'member_ids': self.member_ids,
            'create_time': utils.get_iso_format(self.create_time),
        }
