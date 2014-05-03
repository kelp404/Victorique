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
]

.run ['$injector', ($injector) ->
    $rootScope = $injector.get '$rootScope'
    $stateParams = $injector.get '$stateParams'
    $state = $injector.get '$state'

    $rootScope.$stateParams = $stateParams
    $rootScope.$state = $state
]
