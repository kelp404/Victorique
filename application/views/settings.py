from application.responses import JsonResponse


def get_settings(request):
    result = {
        'user': request.user.dict()
    }
    return JsonResponse(result)
