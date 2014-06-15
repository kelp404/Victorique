angular.module 'v.router', [
    'v.provider'
    'v.controllers'
    'ui.router'
]

.config ['$stateProvider', '$urlRouterProvider', '$locationProvider', ($stateProvider, $urlRouterProvider, $locationProvider) ->

    # html5 mode
    $locationProvider.html5Mode yes

    # redirect other urls
    $urlRouterProvider.otherwise '/'

    # ---------------------------------------------------------
    #
    # ---------------------------------------------------------
    $stateProvider.state 'v',
        url: ''
        templateUrl: '/views/shared/layout.html'

    # ---------------------------------------------------------
    # /
    # ---------------------------------------------------------
    $stateProvider.state 'v.index',
        url: '/'
        controller: 'IndexController'

    # ---------------------------------------------------------
    # /login
    # ---------------------------------------------------------
    $stateProvider.state 'v.login',
        url: '/login'
        resolve:
            title: -> 'Login - '
        views:
            content:
                templateUrl: '/views/login.html'
                controller: 'LoginController'

    # ---------------------------------------------------------
    # /applications
    # ---------------------------------------------------------
    $stateProvider.state 'v.log-default',
        url: '/applications'
        resolve:
            title: -> 'Logs - '
            applications: ['$v', ($v) ->
                $v.api.application.getApplications(0, yes).then (response) ->
                    response.data
            ]
            logs: ['$v', ($v) ->
                $v.api.log.getLogs().then (response) ->
                    response.data
            ]
        views:
            content:
                templateUrl: '/views/log/list.html'
                controller: 'LogsController'
    # ---------------------------------------------------------
    # /applications/:applicationId/logs
    # ---------------------------------------------------------
    $stateProvider.state 'v.log-list',
        url: '/applications/:applicationId/logs?index?keyword'
        resolve:
            title: -> 'Logs - '
            applications: ['$v', ($v) ->
                $v.api.application.getApplications(0, yes).then (response) ->
                    response.data
            ]
            logs: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.log.getLogs($stateParams.applicationId, $stateParams.index, $stateParams.keyword).then (response) ->
                    response.data
            ]
        views:
            content:
                templateUrl: '/views/log/list.html'
                controller: 'LogsController'
    # ---------------------------------------------------------
    # /applications/:applicationId/logs/:logId
    # ---------------------------------------------------------
    $stateProvider.state 'v.log-detail',
        url: '/applications/:applicationId/logs/:logId'
        resolve:
            title: -> 'Log - '
            application: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.application.getApplication($stateParams.applicationId).then (response) ->
                    response.data
            ]
            log: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.log.getLog($stateParams.applicationId, $stateParams.logId).then (response) ->
                    response.data
            ]
        views:
            content:
                templateUrl: '/views/log/detail.html'
                controller: 'LogController'

    # ---------------------------------------------------------
    # /settings
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings',
        url: '/settings'
        resolve:
            title: -> 'Settings - '
        controller: 'SettingsController'
    # ---------------------------------------------------------
    # /settings/profile
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings-profile',
        url: '/settings/profile'
        resolve:
            title: -> 'Profile - Settings - '
            profile: ['$v', ($v) ->
                $v.api.settings.getProfile().then (response) ->
                    response.data
            ]
        views:
            menu:
                templateUrl: '/views/settings/menu.html'
                controller: 'SettingsMenuController'
            content:
                templateUrl: '/views/settings/profile.html'
                controller: 'SettingsProfileController'

    # ---------------------------------------------------------
    # /settings/applications
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings-applications',
        url: '/settings/applications?index'
        resolve:
            title: -> 'Applications - Settings - '
            applications: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.application.getApplications($stateParams.index).then (response) ->
                    response.data
            ]
        views:
            menu:
                templateUrl: '/views/settings/menu.html'
                controller: 'SettingsMenuController'
            content:
                templateUrl: '/views/settings/applications.html'
                controller: 'SettingsApplicationsController'
    # ---------------------------------------------------------
    # /settings/applications/new
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings-applications.new',
        url: '/new'
        resolve:
            title: -> 'Applications - Settings - '
        templateUrl: '/views/modal/application.html'
        controller: 'SettingsNewApplicationController'
    # ---------------------------------------------------------
    # /settings/applications/{applicationId}
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings-applications.detail',
        url: '/:applicationId'
        resolve:
            title: -> 'Application - Settings - '
            application: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.application.getApplication($stateParams.applicationId).then (response) ->
                    response.data
            ]
        templateUrl: '/views/modal/application.html'
        controller: 'SettingsApplicationController'

    # ---------------------------------------------------------
    # /settings/users
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings-users',
        url: '/settings/users?index'
        resolve:
            title: -> 'Users - Settings - '
            users: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.user.getUsers($stateParams.index).then (response) ->
                    response.data
            ]
        views:
            menu:
                templateUrl: '/views/settings/menu.html'
                controller: 'SettingsMenuController'
            content:
                templateUrl: '/views/settings/users.html'
                controller: 'SettingsUsersController'
    # ---------------------------------------------------------
    # /settings/users/new
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings-users.new',
        url: '/new'
        resolve:
            title: -> 'Users - Settings - '
        templateUrl: '/views/modal/user.html'
        controller: 'SettingsNewUserController'
    # ---------------------------------------------------------
    # /settings/users/{userId}
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings-users.detail',
        url: '/:userId'
        resolve:
            title: -> 'Users - Settings - '
            user: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.user.getUser($stateParams.userId).then (response) ->
                    response.data
            ]
        templateUrl: '/views/modal/user.html'
        controller: 'SettingsUserController'
]

.run ['$injector', ($injector) ->
    $rootScope = $injector.get '$rootScope'
    $stateParams = $injector.get '$stateParams'
    $state = $injector.get '$state'
    $v = $injector.get '$v'

    $rootScope.$stateParams = $stateParams
    $rootScope.$state = $state

    # setup NProgress
    NProgress.configure
        showSpinner: no

    # ui.router state change event
    changeStartEvent = null
    fromStateName = null
    toStateName = null
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState) ->
        changeStartEvent = window.event
        fromStateName = fromState.name
        toStateName = toState.name
        NProgress.start()
    $rootScope.$on '$stateChangeSuccess', (event, toState) ->
        NProgress.done()
        if not $v.user.isLogin and toState.name isnt 'v.login'
            $state.go 'v.login'
    $rootScope.$on '$stateChangeError', (event, toState) ->
        NProgress.done()
        if not $v.user.isLogin and toState.name isnt 'v.login'
            $state.go 'v.login'
    $rootScope.$on '$viewContentLoaded', ->
        return if changeStartEvent?.type is 'popstate'
        if fromStateName? and toStateName?
            return if fromStateName.replace(toStateName, '').indexOf('.') is 0
            return if toStateName.replace(fromStateName, '').indexOf('.') is 0
        window.scrollTo 0, 0
]
