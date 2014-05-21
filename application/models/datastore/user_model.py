from google.appengine.ext import db
from google.appengine.api import users
from application import utils


class UserPermission(object):
    anonymous = 0
    root = 1
    normal = 2

class UserModel(db.Model):
    email = db.EmailProperty()
    name = db.StringProperty(indexed=False)
    permission = db.IntegerProperty(default=UserPermission.anonymous)
    create_time = db.DateTimeProperty(auto_now_add=True)

    @property
    def is_login(self):
        return not not self.has_key()

    def dict(self):
        return {
            'is_login': self.is_login,
            'id': self.key().id() if self.has_key() else None,
            'name': self.name,
            'email': self.email,
            'permission': self.permission,
            'create_time': utils.get_iso_format(self.create_time)
        }

    @classmethod
    def authorization(cls):
        """
        User Authorization.
        :returns: UserModel
        """
        google_user = users.get_current_user()
        if not google_user:
            # didn't login with google account
            return UserModel()

        if UserModel.all().count(1) == 0:
            # set up default user with google account
            user = cls.__register_user(google_user, UserPermission.root)
            return user

        if google_user:
            # auth with google account
            members = UserModel.gql('where email = :1', google_user.email().lower()).fetch(1)
            if len(members) > 0:
                # got the user
                user = members[0]
            else:
                # register a new user
                user = cls.__register_user(google_user, UserPermission.normal)
            return user

        return UserModel()

    @classmethod
    def __register_user(cls, google_user, permission=UserPermission.normal):
        """
        Register the user.
        :param google_user: The google.appengine.api.users.get_current_user().
        :param permission: The user's permission.
        :return: The datastore.user_model.UserModel object.
        """
        user = UserModel()
        user.email = google_user.email().lower()
        user.name = google_user.nickname()
        user.permission = permission
        user.put()
        return user

    def put(self, **kwargs):
        """
        Put the model as sync.
        """
        super(UserModel, self).put(**kwargs)
        self.get(self.key())
