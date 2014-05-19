angular.module 'v.controllers.settings', []

.controller 'SettingsController', ['$scope', '$injector', ($scope, $injector) ->
    $state = $injector.get '$state'
    $state.go 'v.settings-profile'
]

.controller 'SettingsProfileController', ['$scope', '$injector', 'profile', ($scope, $injector, profile) ->
    $v = $injector.get '$v'
    $validator = $injector.get '$validator'

    $scope.profile =
        model: profile
        submit: ($event) ->
            $event.preventDefault()
            $validator.validate($scope, 'profile.model').success ->
                $v.api.settings.updateProfile
                    name: $scope.profile.model.name
                .success -> $v.alert.saved()
]

.controller 'SettingsApplicationsController', ['$scope', '$injector', 'applications', ($scope, $injector, applications) ->
    $v = $injector.get '$v'
    $validator = $injector.get '$validator'

    $scope.applications = applications
]
