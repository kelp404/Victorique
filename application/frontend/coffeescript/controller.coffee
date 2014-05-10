angular.module 'v.controller', []

.controller 'NavigationController', ['$scope', '$injector', ($scope, $injector) ->
    $v = $injector.get '$v'
    $scope.user = $v.user
    $scope.url = $v.url
]

.controller 'SettingsController', ['$scope', '$injector', 'settings', ($scope, $injector, settings) ->
    $scope.profile =
        model: settings.user
        submit: ($event) ->
            $event.preventDefault()
            console.log $scope.profile.model
]
