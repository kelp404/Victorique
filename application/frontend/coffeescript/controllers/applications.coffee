angular.module 'v.controllers.applications', []

.controller 'ApplicationsController', ['$scope', '$injector', 'applications', ($scope, $injector, applications) ->
    $rootScope = $injector.get '$rootScope'

    $rootScope.$applications = applications
    if $scope.$state.current.name is 'v.applications' and applications.items.length
        $scope.$state.go 'v.application.logs',
            applicationId: applications.items[0].id
]

.controller 'ApplicationController', ['$scope', '$injector', 'application', ($scope, $injector, application) ->
    $scope.$applications.current = application
    if $scope.$state.current.name is 'v.application'
        $scope.$state.go 'v.application.logs',
            applicationId: application.id
]
