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

    @alert =
        saved: (message='Saved successful.') ->
            ###
            Pop the message to tell user the data hade been saved.
            ###
            $.av.pop
                title: 'Success'
                message: message
                expire: 3000

    @http = (args) =>
        $http args

    @api =
        settings:
            getProfile: =>
                @http
                    method: 'get'
                    url: '/settings/profile'
            updateProfile: (profile) =>
                ###
                @param profile:
                    name: {string}
                ###
                @http
                    method: 'put'
                    url: '/settings/profile'
                    data: profile
            getApplications: =>
                @http
                    method: 'get'
                    url: '/settings/applications'

    # -----------------------------------------------------
    # $get
    # -----------------------------------------------------
    @$get = ['$injector', ($injector) =>
        @setupProviders $injector


        user: @user
        url: @url
        alert: @alert
        api: @api
    ]

    return
