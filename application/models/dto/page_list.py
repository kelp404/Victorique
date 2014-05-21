# -----------------------------------------------
# pager
# -----------------------------------------------
class PageList(list):
    def __init__(self, index=0, size=20, total=0, *args, **kwargs):
        self.__index = index
        self.__size = size
        self.__total = total
        super(PageList, self).__init__(*args, **kwargs)

    @property
    def index(self):
        return self.__index

    @property
    def size(self):
        return self.__size

    @property
    def total(self):
        return self.__total

    @property
    def has_next_page(self):
        return self.__total > (self.__index + 1) * self.__size

    @property
    def has_previous_page(self):
        return self.__index > 0

    @property
    def max_index(self):
        max = self.__total / float(self.__size)
        return int(max) if max > int(max) else int(max) - 1

    def dict(self):
        return {
            'index': self.__index,
            'size': self.__size,
            'total': self.__total,
            'has_next_page': self.has_next_page,
            'has_previous_page': self.has_previous_page,
            'max_index': self.max_index,
            'items': [x.dict() if 'dict' in dir(x) and callable(x.dict) else x for x in self]
        }
