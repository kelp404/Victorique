angular.module 'v.controllers.settings', []

.controller 'SettingsController', ['$scope', '$injector', ($scope, $injector) ->
    $state = $injector.get '$state'
    $state.go 'v.settings-applications'
]

.controller 'SettingsMenuController', ['$scope', '$injector', ($scope, $injector) ->
    $v = $injector.get '$v'

    $scope.isRoot = $v.user.permission is 1
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
        email_notification: yes
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
    $timeout = $injector.get '$timeout'

    $scope.mode = 'edit'
    $scope.application = application
    for member in application.members
        member.isRoot = member.id in application.root_ids
    $scope.$watch 'application.members', ->
        root_ids = []
        for member in $scope.application.members when member.isRoot
            root_ids.push member.id
        $scope.application.root_ids = root_ids
    , yes
    $scope.modal =
        autoShow: yes
        hide: ->
        hiddenCallback: ->
            $state.go 'v.settings-applications', null, reload: yes
    $scope.submit = ->
        $validator.validate($scope, 'application').success ->
            NProgress.start()
            data =
                id: $scope.application.id
                title: $scope.application.title
                description: $scope.application.description
                member_ids: $scope.application.member_ids
                root_ids: $scope.application.root_ids
                email_notification: $scope.application.email_notification
            $v.api.application.updateApplication(data).success ->
                $scope.modal.hide()
    $scope.memberService =
        email: ''
        invite: ($event) ->
            $event.preventDefault()
            $validator.validate($scope, 'memberService').success ->
                NProgress.start()
                $v.api.application.addApplicationMember($scope.application.id, $scope.memberService.email).success (member) ->
                    NProgress.done()
                    $scope.application.member_ids.push member.id
                    $scope.application.members.push member
                    $scope.memberService.email = ''
                    $timeout -> $validator.reset $scope, 'memberService'
        removeMember: ($event, memberId) ->
            $event.preventDefault()
            for index in [0...$scope.application.members.length] when $scope.application.members[index].id is memberId
                $scope.application.members.splice index, 1
                break
            for index in [0...$scope.application.member_ids.length] when $scope.application.member_ids[index] is memberId
                $scope.application.member_ids.splice index, 1
                break
            for index in [0...$scope.application.root_ids.length] when $scope.application.root_ids[index] is memberId
                $scope.application.root_ids.splice index, 1
                break
            return
    $scope.updateAppKey = ->
        NProgress.start()
        data =
            id: $scope.application.id
            app_key: yes
        $v.api.application.updateApplication(data).success (application) ->
            $scope.application.app_key = application.app_key
            NProgress.done()
]

.controller 'SettingsUsersController', ['$scope', '$injector', 'users', ($scope, $injector, users) ->
    $v = $injector.get '$v'
    $state = $injector.get '$state'
    $stateParams = $injector.get '$stateParams'
    $validator = $injector.get '$validator'

    $scope.users = users
    $scope.currentUser = $v.user
    $scope.isRoot = $v.user.permission is 1
    $scope.removeUser = (user, $event) ->
        $event.preventDefault()
        $v.alert.confirm "Do you want to delete the user #{user.name}<#{user.email}>?", (result) ->
            return if not result
            NProgress.start()
            $v.api.user.removeUser(user.id).success ->
                $state.go $state.current, $stateParams, reload: yes
]
.controller 'SettingsNewUserController', ['$scope', '$injector', ($scope, $injector) ->
    $v = $injector.get '$v'
    $validator = $injector.get '$validator'
    $state = $injector.get '$state'

    $scope.mode = 'new'
    $scope.user =
        email: ''
    $scope.modal =
        autoShow: yes
        hide: ->
        hiddenCallback: ->
            $state.go 'v.settings-users', null, reload: yes
    $scope.submit = ->
        $validator.validate($scope, 'user').success ->
            NProgress.start()
            $v.api.user.inviteUser($scope.user.email).success ->
                $scope.modal.hide()
]
.controller 'SettingsUserController', ['$scope', '$injector', 'user', ($scope, $injector, user) ->
    $v = $injector.get '$v'
    $validator = $injector.get '$validator'
    $state = $injector.get '$state'

    $scope.mode = 'edit'
    $scope.user = user
    $scope.modal =
        autoShow: yes
        hide: ->
        hiddenCallback: ->
            $state.go 'v.settings-users', null, reload: yes
    $scope.submit = ->
        $validator.validate($scope, 'user').success ->
            NProgress.start()
            $v.api.user.updateUser($scope.user).success ->
                $scope.modal.hide()
]
