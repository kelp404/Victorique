import json
from wtforms import Field


class DictField(Field):
    def _value(self):
        return self.data
    def process_data(self, value):
        if value is None:
            self.data = None

        if isinstance(value, dict):
            self.data = value
        elif isinstance(value, basestring):
            self.data = json.loads(value)

class ArrayField(Field):
    def _value(self):
        return self.data
    def process_data(self, value):
        if value and isinstance(value, list):
            self.data = value
        else:
            self.data = []
