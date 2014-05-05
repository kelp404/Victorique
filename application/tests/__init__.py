
def patcher(*patchers):
    """
    The decorator for start and stop patchers.
    :param patchers: {tuple} The patchers.
    """
    def decorator(func):
        def wraps(self):
            map(lambda x: x.start(), patchers)
            func(self)
            map(lambda x: x.stop(), patchers)
        return wraps
    return decorator
