class ErrorModel(dict):
    def __init__(self, *args, **kw):
        super(ErrorModel, self).__init__(*args, **kw)
        if 'status' not in self:
            self['status'] = 0
        if 'exception' not in self:
            self['exception'] = ''

    @property
    def exception(self):
        return self['exception']
    @exception.setter
    def exception(self, value):
        self['exception'] = value

    @property
    def status(self):
        return self['status']
    @status.setter
    def status(self, value):
        self['status'] = value