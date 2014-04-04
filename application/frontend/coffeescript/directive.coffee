angular.module 'v.directive', []

.directive 'vNavigation', ->
    restrict: 'A'
    templateUrl: '/views/shared/navigation.html'
    replace: yes
    controller: 'NavigationController'
