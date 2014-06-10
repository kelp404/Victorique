from application import utils
from application.responses import JsonResponse
from application.decorators import authorization
from application.forms.search_form import SearchForm
from application.models.dto.page_list import PageList
from application.models.datastore.user_model import UserModel, UserPermission


@authorization(UserPermission.root)
def get_users(request):
    form = SearchForm(**request.GET.dict())
    query = UserModel.all().order('create_time')
    total = query.count()
    applications = query.fetch(utils.default_page_size, form.index.data * utils.default_page_size)
    return JsonResponse(PageList(form.index.data, utils.default_page_size, total, applications))
