(function() {
  angular.module('v.controllers.applications', []).controller('ApplicationsController', ['$scope', function($scope) {}]);

}).call(this);

(function() {
  angular.module('v.controllers', ['v.controllers.navigation', 'v.controllers.index', 'v.controllers.login', 'v.controllers.settings', 'v.controllers.applications']);

}).call(this);

(function() {
  angular.module('v.controllers.index', []).controller('IndexController', [
    '$scope', '$injector', function($scope, $injector) {
      var $state, $v;
      $v = $injector.get('$v');
      $state = $injector.get('$state');
      if ($v.user.is_login) {
        return $state.go('v.applications');
      } else {
        return $stae.go('v.login');
      }
    }
  ]);

}).call(this);

(function() {
  angular.module('v.controllers.login', []).controller('LoginController', [
    '$scope', '$injector', function($scope, $injector) {
      var $v;
      $v = $injector.get('$v');
      return $scope.url = $v.url;
    }
  ]);

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
    '$scope', '$injector', function($scope, $injector) {
      var $state;
      $state = $injector.get('$state');
      return $state.go('v.settings-profile');
    }
  ]).controller('SettingsProfileController', [
    '$scope', '$injector', 'profile', function($scope, $injector, profile) {
      var $v, $validator;
      $v = $injector.get('$v');
      $validator = $injector.get('$validator');
      return $scope.profile = {
        model: profile,
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
  ]).controller('SettingsApplicationsController', [
    '$scope', '$injector', 'applications', function($scope, $injector, applications) {
      var $state, $stateParams, $v, $validator;
      $v = $injector.get('$v');
      $state = $injector.get('$state');
      $stateParams = $injector.get('$stateParams');
      $validator = $injector.get('$validator');
      $scope.applications = applications;
      return $scope.removeApplication = function(applicationId, $event) {
        $event.preventDefault();
        return $v.api.application.removeApplication(applicationId).success(function() {
          return $state.go($state.current, $stateParams, {
            reload: true
          });
        });
      };
    }
  ]).controller('SettingsNewApplicationController', [
    '$scope', '$injector', function($scope, $injector) {
      var $state, $v, $validator;
      $v = $injector.get('$v');
      $validator = $injector.get('$validator');
      $state = $injector.get('$state');
      $scope.model = {
        title: '',
        description: ''
      };
      $scope.modal = {
        autoShow: true,
        hide: function() {},
        hiddenCallback: function() {
          return $state.go('v.settings-applications', null, {
            reload: true
          });
        }
      };
      return $scope.submit = function() {
        return $validator.validate($scope, 'model').success(function() {
          return $v.api.application.addApplication($scope.model).success(function() {
            return $scope.modal.hide();
          });
        });
      };
    }
  ]).controller('SettingsApplicationController', [
    '$scope', '$injector', 'application', function($scope, $injector, application) {
      var $state, $v, $validator;
      $v = $injector.get('$v');
      $validator = $injector.get('$validator');
      $state = $injector.get('$state');
      $scope.model = application;
      $scope.modal = {
        autoShow: true,
        hide: function() {},
        hiddenCallback: function() {
          return $state.go('v.settings-applications', null, {
            reload: true
          });
        }
      };
      return $scope.submit = function() {
        return $validator.validate($scope, 'model').success(function() {
          return $v.api.application.updateApplication($scope.model).success(function() {
            return $scope.modal.hide();
          });
        });
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
  }).directive('vSettingsMenu', function() {
    return {
      restrict: 'A',
      templateUrl: '/views/settings/menu.html',
      replace: true,
      link: function(scope, element, attrs) {
        return scope.options = scope.$eval(attrs.vSettingsMenu);
      }
    };
  }).directive('vFocus', function() {
    return {
      restrict: 'A',
      link: function(scope, element) {
        return $(element).select();
      }
    };
  }).directive('vModal', function() {
    return {

      /*
      v-modal="scope.modal"
      scope.modal:
          autoShow: {bool} If this modal should pop as automatic, it should be yes.
          hide: -> {function} After link, it is a function for hidden the modal.
          hiddenCallback: ($event) -> {function} After the modal hidden, it will be eval.
       */
      restrict: 'A',
      scope: {
        modal: '=vModal'
      },
      link: function(scope, element) {
        scope.modal.hide = function() {
          return $(element).modal('hide');
        };
        if (scope.modal.hiddenCallback) {
          $(element).on('hidden.bs.modal', function(e) {
            return scope.$apply(function() {
              return scope.$eval(scope.modal.hiddenCallback, {
                $event: e
              });
            });
          });
        }
        $(element).on('shown.bs.modal', function() {
          var $firstController;
          $firstController = $(element).find('form .form-control:first');
          if ($firstController.length) {
            return $firstController.select();
          } else {
            return $(element).find('form [type=submit]').focus();
          }
        });
        if (scope.modal.autoShow) {
          return $(element).modal('show');
        }
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
        getProfile: (function(_this) {
          return function() {
            return _this.http({
              method: 'get',
              url: '/settings/profile'
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
      },
      application: {
        getApplications: (function(_this) {
          return function() {
            return _this.http({
              method: 'get',
              url: '/settings/applications'
            });
          };
        })(this),
        addApplication: (function(_this) {
          return function(application) {

            /*
            @param application:
                title: {string}
                description: {string}
             */
            return _this.http({
              method: 'post',
              url: '/settings/applications',
              data: application
            });
          };
        })(this),
        getApplication: (function(_this) {
          return function(applicationId) {
            return _this.http({
              method: 'get',
              url: "/settings/applications/" + applicationId
            });
          };
        })(this),
        updateApplication: (function(_this) {
          return function(application) {
            return _this.http({
              method: 'put',
              url: "/settings/applications/" + application.id,
              data: application
            });
          };
        })(this),
        removeApplication: (function(_this) {
          return function(applicationId) {
            NProgress.start();
            return _this.http({
              method: 'delete',
              url: "/settings/applications/" + applicationId
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
        url: '/',
        controller: 'IndexController'
      });
      $stateProvider.state('v.login', {
        url: '/login',
        templateUrl: '/views/login.html',
        controller: 'LoginController'
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
      $stateProvider.state('v.settings', {
        url: '/settings',
        controller: 'SettingsController'
      });
      $stateProvider.state('v.settings-profile', {
        url: '/settings/profile',
        resolve: {
          profile: [
            '$v', function($v) {
              return $v.api.settings.getProfile().then(function(response) {
                return response.data;
              });
            }
          ]
        },
        templateUrl: '/views/settings/profile.html',
        controller: 'SettingsProfileController'
      });
      $stateProvider.state('v.settings-applications', {
        url: '/settings/applications',
        resolve: {
          applications: [
            '$v', function($v) {
              return $v.api.application.getApplications().then(function(response) {
                return response.data;
              });
            }
          ]
        },
        templateUrl: '/views/settings/applications.html',
        controller: 'SettingsApplicationsController'
      });
      $stateProvider.state('v.settings-applications.new', {
        url: '/new',
        templateUrl: '/views/modal/application.html',
        controller: 'SettingsNewApplicationController'
      });
      return $stateProvider.state('v.settings-applications.detail', {
        url: '/:applicationId',
        resolve: {
          application: [
            '$v', '$stateParams', function($v, $stateParams) {
              return $v.api.application.getApplication($stateParams.applicationId).then(function(response) {
                return response.data;
              });
            }
          ]
        },
        templateUrl: '/views/modal/application.html',
        controller: 'SettingsApplicationController'
      });
    }
  ]).run([
    '$injector', function($injector) {
      var $rootScope, $state, $stateParams, $v;
      $rootScope = $injector.get('$rootScope');
      $stateParams = $injector.get('$stateParams');
      $state = $injector.get('$state');
      $v = $injector.get('$v');
      $rootScope.$stateParams = $stateParams;
      $rootScope.$state = $state;
      NProgress.configure({
        showSpinner: false
      });
      $rootScope.$on('$stateChangeStart', function() {
        return NProgress.start();
      });
      $rootScope.$on('$stateChangeSuccess', function(event, toState) {
        NProgress.done();
        if (!$v.user.is_login && toState.name !== 'v.login') {
          return $state.go('v.login');
        }
      });
      return $rootScope.$on('$stateChangeError', function(event, toState) {
        NProgress.done();
        if (!$v.user.is_login && toState.name !== 'v.login') {
          return $state.go('v.login');
        }
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
