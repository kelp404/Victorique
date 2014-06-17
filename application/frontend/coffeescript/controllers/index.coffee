angular.module 'v.controllers.index', []

.controller 'IndexController', ['$scope', '$injector', ($scope, $injector) ->
    $v = $injector.get '$v'
    $state = $injector.get '$state'

    if $v.user.isLogin
        $state.go 'v.log-default'
    else
        $state.go 'v.login'
]
