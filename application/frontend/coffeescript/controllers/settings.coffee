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
.controller 'SettingsNewApplicationController', ['$scope', '$injector', ($scope, $injector) ->
    $v = $injector.get '$v'
    $validator = $injector.get '$validator'
    $state = $injector.get '$state'

    $scope.model =
        title: ''
        description: ''
    $scope.modal =
        autoShow: yes
        hide: ->
        hiddenCallback: ->
            $state.go 'v.settings-applications', null, reload: yes
    $scope.submit = ->
        $validator.validate($scope, 'model').success ->
            $v.api.settings.addApplication($scope.model).success ->
                $scope.modal.hide()
]