angular.module 'v.controllers.settings', []

.controller 'SettingsController', ['$scope', '$injector', 'settings', ($scope, $injector, settings) ->
    $v = $injector.get '$v'
    $validator = $injector.get '$validator'

    $scope.profile =
        model: settings.user
        submit: ($event) ->
            $event.preventDefault()
            $validator.validate($scope, 'profile.model').success ->
                $v.api.settings.updateProfile
                    name: $scope.profile.model.name
                .success -> $v.alert.saved()
]
