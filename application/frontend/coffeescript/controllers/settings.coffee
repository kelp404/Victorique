angular.module 'v.controllers.settings', []

.controller 'SettingsController', ['$scope', '$injector', 'settings', ($scope, $injector, settings) ->
    $scope.profile =
        model: settings.user
        submit: ($event) ->
            $event.preventDefault()
            console.log $scope.profile.model
]
