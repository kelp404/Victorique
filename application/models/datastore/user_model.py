from google.appengine.ext import db
from google.appengine.api import users


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
            user.is_login = True
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
            user.is_login = True
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
        user.get(user.key())
        return user