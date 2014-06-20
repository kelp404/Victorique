angular.module 'v.controllers.navigation', []

.controller 'NavigationController', ['$scope', '$injector', ($scope, $injector) ->
    $v = $injector.get '$v'
    $scope.url = $v.url
]
