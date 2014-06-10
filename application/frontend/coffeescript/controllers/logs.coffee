angular.module 'v.controllers.logs', []

.controller 'LogsController', ['$scope', '$injector', 'applications', 'logs', ($scope, $injector, applications, logs) ->
    $state = $injector.get '$state'
    $stateParams = $injector.get '$stateParams'

    $scope.applications = applications
    $scope.logs = logs
    $scope.currentApplication = logs.application
    $scope.keyword = $stateParams.keyword
    $scope.search = ($event, keyword) ->
        $event.preventDefault()
        $state.go 'v.log-list',
            applicationId: $scope.currentApplication.id
            keyword: keyword
        , reload: yes
    $scope.showDetail = (logId) ->
        $state.go 'v.log-detail',
            applicationId: $scope.currentApplication.id
            logId: logId
        , reload: yes
]

.controller 'LogController', ['$scope', 'application', 'log', ($scope, application, log) ->
    $scope.application = application
    $scope.log = log
]
