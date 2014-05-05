angular.module 'v.provider', []

.provider '$v', ->
    $injector = null
    $http = null

    # -----------------------------------------------------
    # private methods
    # -----------------------------------------------------
    @setupProviders = (injector) ->
        $injector = injector
        $http = $injector.get '$http'


    # -----------------------------------------------------
    # public methods
    # -----------------------------------------------------
    @user = window.user
    @url = window.url

    @http = (args) =>
        $http args

    @api =
        settings:
            getSettings: =>
                @http
                    method: 'get'
                    url: '/settings'

    # -----------------------------------------------------
    # $get
    # -----------------------------------------------------
    @$get = ['$injector', ($injector) =>
        @setupProviders $injector


        user: @user
        url: @url
        api: @api
    ]

    return
