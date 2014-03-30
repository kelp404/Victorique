angular.module 'v.provider', []

.provider '$v', ->
    # -----------------------------------------------------
    # public methods
    # -----------------------------------------------------
    @user = window.user
    @url = window.url

    # -----------------------------------------------------
    # $get
    # -----------------------------------------------------
    @$get = ['$injector', ($injector) =>

        user: @user
        url: @url
    ]

    return
