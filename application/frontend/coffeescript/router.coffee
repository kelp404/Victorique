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
        templateUrl: '/views/login.html'
        controller: 'LoginController'

    # ---------------------------------------------------------
    # /applications
    # ---------------------------------------------------------
    $stateProvider.state 'v.log-default',
        url: '/applications'
        resolve:
            applications: ['$v', ($v) ->
                $v.api.application.getApplications(0, yes).then (response) ->
                    response.data
            ]
            logs: ['$v', ($v) ->
                $v.api.log.getLogs().then (response) ->
                    response.data
            ]
        templateUrl: '/views/log/list.html'
        controller: 'LogsController'
    # ---------------------------------------------------------
    # /applications/:applicationId/logs
    # ---------------------------------------------------------
    $stateProvider.state 'v.log-list',
        url: '/applications/:applicationId/logs?index'
        resolve:
            applications: ['$v', ($v) ->
                $v.api.application.getApplications(0, yes).then (response) ->
                    response.data
            ]
            logs: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.log.getLogs($stateParams.applicationId, $stateParams.index).then (response) ->
                    response.data
            ]
        templateUrl: '/views/log/list.html'
        controller: 'LogsController'
    # ---------------------------------------------------------
    # /applications/:applicationId/logs/:logId
    # ---------------------------------------------------------
    $stateProvider.state 'v.log-detail',
        url: '/applications/:applicationId/logs/:logId'
        resolve:
            application: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.application.getApplication($stateParams.applicationId).then (response) ->
                    response.data
            ]
            log: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.log.getLog($stateParams.applicationId, $stateParams.logId).then (response) ->
                    response.data
            ]
        templateUrl: '/views/log/detail.html'
        controller: 'LogController'

    # ---------------------------------------------------------
    # /settings
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings',
        url: '/settings'
        controller: 'SettingsController'
    # ---------------------------------------------------------
    # /settings/profile
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings-profile',
        url: '/settings/profile'
        resolve:
            profile: ['$v', ($v) ->
                $v.api.settings.getProfile().then (response) ->
                    response.data
            ]
        templateUrl: '/views/settings/profile.html'
        controller: 'SettingsProfileController'
    # ---------------------------------------------------------
    # /settings/application
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings-applications',
        url: '/settings/applications?index'
        resolve:
            applications: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.application.getApplications($stateParams.index).then (response) ->
                    response.data
            ]
        templateUrl: '/views/settings/applications.html'
        controller: 'SettingsApplicationsController'
    # ---------------------------------------------------------
    # /settings/application/new
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings-applications.new',
        url: '/new'
        templateUrl: '/views/modal/application.html'
        controller: 'SettingsNewApplicationController'
    # ---------------------------------------------------------
    # /settings/application/{applicationId}
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings-applications.detail',
        url: '/:applicationId'
        resolve:
            application: ['$v', '$stateParams', ($v, $stateParams) ->
                $v.api.application.getApplication($stateParams.applicationId).then (response) ->
                    response.data
            ]
        templateUrl: '/views/modal/application.html'
        controller: 'SettingsApplicationController'
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
    $rootScope.$on '$stateChangeStart', ->
        NProgress.start()
    $rootScope.$on '$stateChangeSuccess', (event, toState) ->
        NProgress.done()
        if not $v.user.is_login and toState.name isnt 'v.login'
            $state.go 'v.login'
    $rootScope.$on '$stateChangeError', (event, toState) ->
        NProgress.done()
        if not $v.user.is_login and toState.name isnt 'v.login'
            $state.go 'v.login'
]
