from google.appengine.ext import db


class BaseModel(db.Model):
    def put(self, **kwargs):
        """
        Put the model as sync.
        """
        super(BaseModel, self).put(**kwargs)
        self.get(self.key())

    def delete(self, **kwargs):
        """
        Delete the model as sync.
        """
        super(BaseModel, self).delete(**kwargs)
        self.get(self.key())
