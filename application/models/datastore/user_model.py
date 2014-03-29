from google.appengine.ext import db


class UserPermission(object):
    anonymous = 0
    root = 1
    normal = 2

class UserModel(db.Model):
    is_login = False
    email = db.EmailProperty()
    name = db.StringProperty(indexed=False)
    permission = db.IntegerProperty(default=UserPermission.normal)
    create_time = db.DateTimeProperty(auto_now_add=True)

    def dict(self):
        return {
            'is_login': self.is_login,
            'id': self.key().id(),
            'name': self.name,
            'email': self.email,
            'permission': self.permission,
            'create_time': self.create_time.strftime('%Y-%m-%dT%H:%M:%S.%fZ')
        }
