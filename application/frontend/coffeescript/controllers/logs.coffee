angular.module 'v.controllers.logs', []

.controller 'LogsController', ['$scope', 'logs', ($scope, logs) ->
    $scope.logs = logs
    $scope.keyword = $scope.$stateParams.keyword
    $scope.search = ($event, keyword) ->
        $event.preventDefault()
        $scope.$state.go $scope.$state.current.name,
            applicationId: $scope.$applications.current.id
            keyword: keyword
    $scope.showDetail = (logId) ->
        $scope.$state.go 'v.application.log',
            applicationId: $scope.$applications.current.id
            logId: logId
]

.controller 'LogController', ['$scope', '$injector', 'log', ($scope, $injector, log) ->
    $v = $injector.get '$v'

    $scope.log = log
    $scope.jsonStringify = (json) ->
        if typeof(json) is 'object'
            try
                return JSON.stringify json, null, 2
        return json
    $scope.closeLog = ($event) ->
        $event.preventDefault()
        NProgress.start()
        $v.api.log.updateLog $scope.$applications.current.id,
            id: log.id
            is_close: yes
        .success (result) ->
            NProgress.done()
            $scope.log = result
]
