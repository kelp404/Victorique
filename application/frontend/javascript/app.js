(function() {
  angular.module('v.controllers.applications', []).controller('ApplicationsController', ['$scope', function($scope) {}]);

}).call(this);

(function() {
  angular.module('v.controllers', ['v.controllers.navigation', 'v.controllers.settings', 'v.controllers.applications']);

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
      var $v, $validator;
      $v = $injector.get('$v');
      $validator = $injector.get('$validator');
      return $scope.profile = {
        model: settings.user,
        submit: function($event) {
          $event.preventDefault();
          return $validator.validate($scope, 'profile.model').success(function() {
            return $v.api.settings.updateProfile({
              name: $scope.profile.model.name
            }).success(function() {
              return $v.alert.saved();
            });
          });
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
  angular.module('v', ['v.initial', 'v.router', 'v.directive', 'v.validations']);

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
    this.alert = {
      saved: function(message) {
        if (message == null) {
          message = 'Saved successful.';
        }

        /*
        Pop the message to tell user the data hade been saved.
         */
        return $.av.pop({
          title: 'Success',
          message: message,
          expire: 3000
        });
      }
    };
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
        })(this),
        updateProfile: (function(_this) {
          return function(profile) {

            /*
            @param profile:
                name: {string}
             */
            return _this.http({
              method: 'put',
              url: '/settings/profile',
              data: profile
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
            alert: _this.alert,
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
      $stateProvider.state('v.applications', {
        url: '/applications',
        resolve: [
          '$v', function($v) {
            return null;
          }
        ],
        templateUrl: '/views/applications/applications.html',
        controller: 'ApplicationsController'
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

(function() {
  angular.module('v.validations', ['validator']).config([
    '$validatorProvider', function($validatorProvider) {
      return $validatorProvider.register('required', {
        validator: /.+/,
        error: 'This field is required.'
      });
    }
  ]);

}).call(this);
