angular.module 'v.controllers.logs', []

.controller 'LogsController', ['$scope', 'applications', 'logs', ($scope, applications, logs) ->
    $scope.applications = applications
    $scope.logs = logs
    $scope.currentApplication = logs.application
]
