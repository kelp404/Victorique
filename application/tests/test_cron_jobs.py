import unittest
from datetime import datetime
from mock import MagicMock, patch
from application.tests import patcher
from application.cron_jobs import db, search, ApplicationModel, LogModel, ClearLogsHandler


class TestCronJobs(unittest.TestCase):
    @patcher(
        patch('application.cron_jobs.ApplicationModel.all', new=MagicMock()),
    )
    def test_cron_jobs_clear_logs_handler_get(self):
        ApplicationModel.all.return_value = [MagicMock()]
        handler = ClearLogsHandler()
        handler._ClearLogsHandler__delete_text_search = MagicMock()
        handler._ClearLogsHandler__delete_data_store = MagicMock()
        handler.get()
        self.assertTrue(ApplicationModel.all.called)
        self.assertTrue(handler._ClearLogsHandler__delete_text_search.called)
        self.assertTrue(handler._ClearLogsHandler__delete_data_store.called)

    @patcher(
        patch('application.cron_jobs.search.Index', new=MagicMock()),
    )
    def test_cron_jobs_clear_logs_handler__delete_text_search(self):
        handler = ClearLogsHandler()
        handler._ClearLogsHandler__delete_text_search('name', 'query')
        search.Index.assert_called_with(namespace='Logs', name='name')
        search.Index().search.assert_called_with('query')
        search.Index().delete.assert_called_with([])

    @patcher(
        patch('application.cron_jobs.LogModel.all', new=MagicMock()),
        patch('application.cron_jobs.db.delete', new=MagicMock()),
    )
    def test_cron_jobs_clear_logs_handler__delete_data_store(self):
        date_tag = datetime.utcnow()
        handler = ClearLogsHandler()
        handler._ClearLogsHandler__delete_data_store(date_tag)
        LogModel.all().filter.assert_called_with('update_time <=', date_tag)
        LogModel.all().filter().fetch.assert_called_with(1000)
        db.delete.assert_called_with(LogModel.all().filter().fetch())
