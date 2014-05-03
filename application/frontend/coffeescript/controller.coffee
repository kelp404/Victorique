angular.module 'v.controller', []

.controller 'NavigationController', ['$scope', '$injector', ($scope, $injector) ->
    $v = $injector.get '$v'
    $scope.user = $v.user
    $scope.url = $v.url
]
