angular.module 'v.controllers.applications', []

.controller 'ApplicationController', ['$scope', 'application', ($scope, application) ->
    $scope.$applications.current = application
    if $scope.$state.current.name is 'v.application'
        $scope.$state.go 'v.application.logs',
            applicationId: application.id
]
