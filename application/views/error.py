# -*- coding: utf-8 -*-

from django.template import loader, RequestContext, Context
from django import http
from application.models.dto.error_model import ErrorModel


def bad_request(request):
    template = loader.get_template('error/default.html')
    model = ErrorModel(
        status=400,
        exception='Bad Request'
    )
    return http.HttpResponseBadRequest(template.render(RequestContext(request, model)))

def permission_denied(request):
    template = loader.get_template('error/default.html')
    model = ErrorModel(
        status=403,
        exception='Permission Denied'
    )
    return http.HttpResponseForbidden(template.render(RequestContext(request, model)))

def page_not_found(request):
    template = loader.get_template('error/default.html')
    model = ErrorModel(
        status=404,
        exception='%s Not Found' % request.path
    )
    return http.HttpResponseNotFound(template.render(RequestContext(request, model)))

def method_not_allowed(request):
    template = loader.get_template('error/default.html')
    model = ErrorModel(
        status=405,
        exception='%s Not Allowed' % request.method
    )
    return http.HttpResponse(status=405, content=template.render(RequestContext(request, model)))

def server_error(request):
    template = loader.get_template('error/default.html')
    model = ErrorModel(
        status=500,
        exception='這一定是宿命'
    )
    return http.HttpResponseServerError(template.render(Context(model)))