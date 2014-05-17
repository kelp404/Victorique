(function() {
  angular.module('v.controllers', ['v.controllers.navigation', 'v.controllers.settings']);

}).call(this);

(function() {
  angular.module('v.controllers.navigation', []).controller('NavigationController', [
    '$scope', '$injector', function($scope, $injector) {
      var $v;
      $v = $injector.get('$v');
      $scope.user = $v.user;
      return $scope.url = $v.url;
    }
  ]);

}).call(this);

(function() {
  angular.module('v.controllers.settings', []).controller('SettingsController', [
    '$scope', '$injector', 'settings', function($scope, $injector, settings) {
      return $scope.profile = {
        model: settings.user,
        submit: function($event) {
          $event.preventDefault();
          return console.log($scope.profile.model);
        }
      };
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
  }).directive('vFocus', function() {
    return {
      restrict: 'A',
      link: function(scope, element) {
        return $(element).select();
      }
    };
  }).directive('vScrollTo', function() {
    return {
      restrict: 'A',
      link: function(scope, element) {
        var link, _i, _len, _ref;
        _ref = $(element).find('a');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          link = _ref[_i];
          $(link).click(function(event) {
            var $target;
            event.preventDefault();
            $target = $($(this).attr('href'));
            if (!$target.length) {
              return;
            }
            $(element).find('li.active').removeClass('active');
            $(this).parent('li').addClass('active');
            return $('html,body').animate({
              scrollTop: $target.offset().top - 60
            }, 500, 'easeOutExpo', function() {
              return $target.find('input:not([type=hidden]):first').select();
            });
          });
        }
      }
    };
  });

}).call(this);

(function() {
  angular.module('v.initial', []).config(function() {
    return $.extend($.easing, {
      easeOutExpo: function(x, t, b, c, d) {
        if (t === d) {
          return b + c;
        } else {
          return c * (-Math.pow(2, -10 * t / d) + 1) + b;
        }
      }
    });
  });

}).call(this);

(function() {
  angular.module('v', ['v.initial', 'v.router', 'v.directive']);

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
  angular.module('v.router', ['v.provider', 'v.controllers', 'ui.router']).config([
    '$stateProvider', '$urlRouterProvider', '$locationProvider', function($stateProvider, $urlRouterProvider, $locationProvider) {
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
          settings: [
            '$v', function($v) {
              return $v.api.settings.getSettings().then(function(response) {
                return response.data;
              });
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
      $rootScope.$state = $state;
      NProgress.configure({
        showSpinner: false
      });
      $rootScope.$on('$stateChangeStart', function() {
        return NProgress.start();
      });
      $rootScope.$on('$stateChangeSuccess', function() {
        return NProgress.done();
      });
      return $rootScope.$on('$stateChangeError', function() {
        return NProgress.done();
      });
    }
  ]);

}).call(this);
