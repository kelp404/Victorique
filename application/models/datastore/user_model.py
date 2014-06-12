from google.appengine.ext import db
from google.appengine.api import users
from django.conf import settings
from application import utils
from application.models.datastore.base_model import BaseModel


class UserPermission(object):
    anonymous = 0
    root = 1
    normal = 2

class UserModel(BaseModel):
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
                return members[0]
            elif getattr(settings, 'ALLOW_REGISTER', False):
                # register a new user
                return cls.__register_user(google_user, UserPermission.normal)
        return UserModel()

    @classmethod
    def __register_user(cls, google_user, permission=UserPermission.normal):
        """
        Register the user.
        :param google_user: The google.appengine.api.users.get_current_user().
        :param permission: The user's permission.
        :return: The datastore.user_model.UserModel object.
        """
        user = UserModel(
            email=google_user.email().lower(),
            name=google_user.nickname(),
            permission=permission,
        )
        user.put()
        return user
