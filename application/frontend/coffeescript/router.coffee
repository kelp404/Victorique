angular.module 'v.router', ['v.provider', 'v.controller', 'ui.router']

.config ['$stateProvider', '$urlRouterProvider', '$locationProvider', '$vProvider', ($stateProvider, $urlRouterProvider, $locationProvider, $vProvider) ->

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

    # ---------------------------------------------------------
    # /settings
    # ---------------------------------------------------------
    $stateProvider.state 'v.settings',
        url: '/settings'
        resolve:
            settings: -> null
            settings: ['$v', ($v) ->
                $v.api.settings.getSettings()
            ]
        templateUrl: '/views/settings/settings.html'
        controller: 'SettingsController'
]

.run ['$injector', ($injector) ->
    $rootScope = $injector.get '$rootScope'
    $stateParams = $injector.get '$stateParams'
    $state = $injector.get '$state'

    $rootScope.$stateParams = $stateParams
    $rootScope.$state = $state
]
