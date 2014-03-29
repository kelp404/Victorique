from django.template.response import TemplateResponse


def base_view(request):
    return TemplateResponse(request, 'base.html')
