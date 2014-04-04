angular.module 'v.controller', []

.controller 'BaseController', ['$scope', '$injector', ($scope, $injector) ->
    $v = $injector.get '$v'

    $scope.user = $v.user
    $scope.url = $v.url
]

.controller 'NavigationController', ['$scope', ($scope) ->

]
