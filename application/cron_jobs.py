from datetime import datetime, timedelta
import webapp2
from google.appengine.ext import db
from google.appengine.api import search
from application.settings import LOG_EXPIRATION
from application.models.datastore.application_model import ApplicationModel
from application.models.datastore.log_model import LogModel


class ClearLogsHandler(webapp2.RequestHandler):
    """
    Clear log data.
    """
    def get(self):
        date_tag = datetime.utcnow() - timedelta(days=LOG_EXPIRATION)
        options = search.QueryOptions(returned_fields=['doc_id'])
        query = search.Query(query_string='update_time<=%s' % date_tag.strftime('%Y-%m-%d'), options=options)
        # clear logs
        for application in ApplicationModel.all():
            self.__delete_text_search(str(application.key().id()), query)
        self.__delete_data_store(date_tag)

    def __delete_text_search(self, name, query):
        """
        Delete text search documents.
        :param name: {string} schema name
        :param query:
        """
        index = search.Index(namespace='Logs', name=name)
        try:
            # delete document in text search
            document_ids = [x.doc_id for x in index.search(query)]
            index.delete(document_ids)
        except Exception:
            pass

    def __delete_data_store(self, date_tag):
        logs = LogModel.all().filter('update_time <=', date_tag).fetch(1000)
        db.delete(logs)


app = webapp2.WSGIApplication([
    ('/cron_jobs/cleanup', ClearLogsHandler)
])
