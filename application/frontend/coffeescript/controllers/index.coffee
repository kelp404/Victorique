angular.module 'v.controllers.index', []

.controller 'IndexController', ['$scope', ($scope) ->
    if $scope.$user.isLogin
        if $scope.$state.current.name is 'v.index' and $scope.$applications.items.length
            $scope.$state.go 'v.application.logs',
                applicationId: $scope.$applications.items[0].id
    else
        $scope.$state.go 'v.login'
]
