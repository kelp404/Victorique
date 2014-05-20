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
    $stateProvider.state 'v.applications',
        url: '/applications'
        resolve: ['$v', ($v) ->
            null
        ]
        templateUrl: '/views/applications/applications.html'
        controller: 'ApplicationsController'

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
        url: '/settings/applications'
        resolve:
            applications: ['$v', ($v) ->
                $v.api.settings.getApplications().then (response) ->
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
