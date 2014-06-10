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
                NProgress.start()
                $v.api.settings.updateProfile
                    name: $scope.profile.model.name
                .success ->
                    NProgress.done()
                    $v.alert.saved()
]

.controller 'SettingsApplicationsController', ['$scope', '$injector', 'applications', ($scope, $injector, applications) ->
    $v = $injector.get '$v'
    $state = $injector.get '$state'
    $stateParams = $injector.get '$stateParams'
    $validator = $injector.get '$validator'

    $scope.applications = applications
    $scope.removeApplication = (application, $event) ->
        $event.preventDefault()
        $v.alert.confirm "Do you want to delete the application #{application.title}?", (result) ->
            return if not result
            NProgress.start()
            $v.api.application.removeApplication(application.id).success ->
                $state.go $state.current, $stateParams, reload: yes
]
.controller 'SettingsNewApplicationController', ['$scope', '$injector', ($scope, $injector) ->
    $v = $injector.get '$v'
    $validator = $injector.get '$validator'
    $state = $injector.get '$state'

    $scope.mode = 'new'
    $scope.application =
        title: ''
        description: ''
    $scope.modal =
        autoShow: yes
        hide: ->
        hiddenCallback: ->
            $state.go 'v.settings-applications', null, reload: yes
    $scope.submit = ->
        $validator.validate($scope, 'application').success ->
            NProgress.start()
            $v.api.application.addApplication($scope.application).success ->
                $scope.modal.hide()
]
.controller 'SettingsApplicationController', ['$scope', '$injector', 'application', ($scope, $injector, application) ->
    $v = $injector.get '$v'
    $validator = $injector.get '$validator'
    $state = $injector.get '$state'

    $scope.mode = 'edit'
    $scope.application = application
    $scope.modal =
        autoShow: yes
        hide: ->
        hiddenCallback: ->
            $state.go 'v.settings-applications', null, reload: yes
    $scope.submit = ->
        $validator.validate($scope, 'application').success ->
            NProgress.start()
            $v.api.application.updateApplication($scope.application).success ->
                $scope.modal.hide()
]

.controller 'SettingsUsersController', ['$scope', '$injector', 'users', ($scope, $injector, users) ->
    $v = $injector.get '$v'
    $state = $injector.get '$state'
    $stateParams = $injector.get '$stateParams'
    $validator = $injector.get '$validator'

    $scope.users = users
]
