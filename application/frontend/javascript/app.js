(function() {
  angular.module('v.controller', []).controller('NavigationController', [
    '$scope', '$injector', function($scope, $injector) {
      var $v;
      $v = $injector.get('$v');
      $scope.user = $v.user;
      return $scope.url = $v.url;
    }
  ]);

}).call(this);

(function() {
  angular.module('v.directive', []).directive('vNavigation', function() {
    return {
      restrict: 'A',
      templateUrl: '/views/shared/navigation.html',
      replace: true,
      controller: 'NavigationController'
    };
  });

}).call(this);

(function() {
  angular.module('v', ['v.router', 'v.directive']);

}).call(this);

(function() {
  angular.module('v.provider', []).provider('$v', function() {
    this.user = window.user;
    this.url = window.url;
    this.$get = [
      '$injector', (function(_this) {
        return function($injector) {
          return {
            user: _this.user,
            url: _this.url
          };
        };
      })(this)
    ];
  });

}).call(this);

(function() {
  angular.module('v.router', ['v.provider', 'v.controller', 'ui.router']).config([
    '$stateProvider', '$urlRouterProvider', '$locationProvider', '$vProvider', function($stateProvider, $urlRouterProvider, $locationProvider, $vProvider) {
      $locationProvider.html5Mode(true);
      $urlRouterProvider.otherwise('/');
      $stateProvider.state('v', {
        url: '',
        templateUrl: '/views/shared/layout.html'
      });
      return $stateProvider.state('v.index', {
        url: '/'
      });
    }
  ]).run([
    '$injector', function($injector) {
      var $rootScope, $state, $stateParams;
      $rootScope = $injector.get('$rootScope');
      $stateParams = $injector.get('$stateParams');
      $state = $injector.get('$state');
      $rootScope.$stateParams = $stateParams;
      return $rootScope.$state = $state;
    }
  ]);

}).call(this);
