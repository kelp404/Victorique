(function() {
  angular.module('v.controller', []).controller('BaseController', [
    '$scope', '$injector', function($scope, $injector) {
      var $v;
      $v = $injector.get('$v');
      $scope.user = $v.user;
      return $scope.url = $v.url;
    }
  ]);

}).call(this);

(function() {
  angular.module('v.directive', []);

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
      return $stateProvider.state('v', {
        url: '/',
        templateUrl: '/views/shared/layout.html',
        controller: 'BaseController'
      });
    }
  ]);

}).call(this);
