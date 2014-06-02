angular.module 'v.controllers.applications', []

.controller 'ApplicationsController', ['$scope', 'applications', ($scope, applications) ->
    $scope.applications = applications
]
