angular.module 'v.controllers.navigation', []

.controller 'NavigationController', ['$scope', '$injector', ($scope, $injector) ->
    $v = $injector.get '$v'
    $scope.user = $v.user
    $scope.url = $v.url
]
