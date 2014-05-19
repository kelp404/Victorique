angular.module 'v.controllers.login', []

.controller 'LoginController', ['$scope', '$injector', ($scope, $injector) ->
    $v = $injector.get '$v'
    $scope.url = $v.url
]
