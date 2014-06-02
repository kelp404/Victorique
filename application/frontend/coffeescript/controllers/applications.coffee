angular.module 'v.controllers.applications', []

.controller 'ApplicationsController', ['$scope', 'applications', 'logs', ($scope, applications, logs) ->
    $scope.applications = applications
    $scope.logs = logs
    $scope.currentApplication = logs.application
]
