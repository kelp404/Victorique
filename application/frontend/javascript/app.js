(function() {
  angular.module('v.controller', []).controller('NavigationController', [
    '$scope', '$injector', function($scope, $injector) {
      var $v;
      $v = $injector.get('$v');
      $scope.user = $v.user;
      return $scope.url = $v.url;
    }
  ]).controller('SettingsController', ['$scope', '$injector', function($scope, $injector) {}]);

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
    var $http, $injector;
    $injector = null;
    $http = null;
    this.setupProviders = function(injector) {
      $injector = injector;
      return $http = $injector.get('$http');
    };
    this.user = window.user;
    this.url = window.url;
    this.http = (function(_this) {
      return function(args) {
        return $http(args);
      };
    })(this);
    this.api = {
      settings: {
        getSettings: (function(_this) {
          return function() {
            return _this.http({
              method: 'get',
              url: '/settings'
            });
          };
        })(this)
      }
    };
    this.$get = [
      '$injector', (function(_this) {
        return function($injector) {
          _this.setupProviders($injector);
          return {
            user: _this.user,
            url: _this.url,
            api: _this.api
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
      $stateProvider.state('v.index', {
        url: '/'
      });
      return $stateProvider.state('v.settings', {
        url: '/settings',
        resolve: {
          settings: function() {
            return null;
          },
          settings: [
            '$v', function($v) {
              return $v.api.settings.getSettings();
            }
          ]
        },
        templateUrl: '/views/settings/settings.html',
        controller: 'SettingsController'
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
