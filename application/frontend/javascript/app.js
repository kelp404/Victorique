(function() {
  angular.module('v.controllers', ['v.controllers.navigation', 'v.controllers.index', 'v.controllers.login', 'v.controllers.settings', 'v.controllers.logs']);

}).call(this);

(function() {
  angular.module('v.controllers.index', []).controller('IndexController', [
    '$scope', '$injector', function($scope, $injector) {
      var $state, $v;
      $v = $injector.get('$v');
      $state = $injector.get('$state');
      if ($v.user.isLogin) {
        return $state.go('v.log-default');
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
  angular.module('v.controllers.logs', []).controller('LogsController', [
    '$scope', '$injector', 'applications', 'logs', function($scope, $injector, applications, logs) {
      var $state, $stateParams;
      $state = $injector.get('$state');
      $stateParams = $injector.get('$stateParams');
      $scope.applications = applications;
      $scope.logs = logs;
      $scope.currentApplication = logs.application;
      $scope.keyword = $stateParams.keyword;
      $scope.search = function($event, keyword) {
        $event.preventDefault();
        return $state.go('v.log-list', {
          applicationId: $scope.currentApplication.id,
          keyword: keyword
        }, {
          reload: true
        });
      };
      return $scope.showDetail = function(logId) {
        return $state.go('v.log-detail', {
          applicationId: $scope.currentApplication.id,
          logId: logId
        }, {
          reload: true
        });
      };
    }
  ]).controller('LogController', [
    '$scope', 'application', 'log', function($scope, application, log) {
      $scope.application = application;
      return $scope.log = log;
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
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('v.controllers.settings', []).controller('SettingsController', [
    '$scope', '$injector', function($scope, $injector) {
      var $state;
      $state = $injector.get('$state');
      return $state.go('v.settings-applications');
    }
  ]).controller('SettingsMenuController', [
    '$scope', '$injector', function($scope, $injector) {
      var $v;
      $v = $injector.get('$v');
      return $scope.isRoot = $v.user.permission === 1;
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
            NProgress.start();
            return $v.api.settings.updateProfile({
              name: $scope.profile.model.name
            }).success(function() {
              NProgress.done();
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
      return $scope.removeApplication = function(application, $event) {
        $event.preventDefault();
        return $v.alert.confirm("Do you want to delete the application " + application.title + "?", function(result) {
          if (!result) {
            return;
          }
          NProgress.start();
          return $v.api.application.removeApplication(application.id).success(function() {
            return $state.go($state.current, $stateParams, {
              reload: true
            });
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
      $scope.mode = 'new';
      $scope.application = {
        title: '',
        description: '',
        email_notification: true
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
        return $validator.validate($scope, 'application').success(function() {
          NProgress.start();
          return $v.api.application.addApplication($scope.application).success(function() {
            return $scope.modal.hide();
          });
        });
      };
    }
  ]).controller('SettingsApplicationController', [
    '$scope', '$injector', 'application', function($scope, $injector, application) {
      var $state, $timeout, $v, $validator, member, _i, _len, _ref, _ref1;
      $v = $injector.get('$v');
      $validator = $injector.get('$validator');
      $state = $injector.get('$state');
      $timeout = $injector.get('$timeout');
      $scope.mode = 'edit';
      $scope.application = application;
      _ref = application.members;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        member = _ref[_i];
        member.isRoot = (_ref1 = member.id, __indexOf.call(application.root_ids, _ref1) >= 0);
      }
      $scope.$watch('application.members', function() {
        var root_ids, _j, _len1, _ref2;
        root_ids = [];
        _ref2 = $scope.application.members;
        for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
          member = _ref2[_j];
          if (member.isRoot) {
            root_ids.push(member.id);
          }
        }
        return $scope.application.root_ids = root_ids;
      }, true);
      $scope.modal = {
        autoShow: true,
        hide: function() {},
        hiddenCallback: function() {
          return $state.go('v.settings-applications', null, {
            reload: true
          });
        }
      };
      $scope.submit = function() {
        return $validator.validate($scope, 'application').success(function() {
          var data;
          NProgress.start();
          data = {
            id: $scope.application.id,
            title: $scope.application.title,
            description: $scope.application.description,
            member_ids: $scope.application.member_ids,
            root_ids: $scope.application.root_ids,
            email_notification: $scope.application.email_notification
          };
          return $v.api.application.updateApplication(data).success(function() {
            return $scope.modal.hide();
          });
        });
      };
      $scope.memberService = {
        email: '',
        invite: function($event) {
          $event.preventDefault();
          return $validator.validate($scope, 'memberService').success(function() {
            NProgress.start();
            return $v.api.application.addApplicationMember($scope.application.id, $scope.memberService.email).success(function(member) {
              NProgress.done();
              $scope.application.member_ids.push(member.id);
              $scope.application.members.push(member);
              $scope.memberService.email = '';
              return $timeout(function() {
                return $validator.reset($scope, 'memberService');
              });
            });
          });
        },
        removeMember: function($event, memberId) {
          var index, _j, _k, _l, _ref2, _ref3, _ref4;
          $event.preventDefault();
          for (index = _j = 0, _ref2 = $scope.application.members.length; 0 <= _ref2 ? _j < _ref2 : _j > _ref2; index = 0 <= _ref2 ? ++_j : --_j) {
            if (!($scope.application.members[index].id === memberId)) {
              continue;
            }
            $scope.application.members.splice(index, 1);
            break;
          }
          for (index = _k = 0, _ref3 = $scope.application.member_ids.length; 0 <= _ref3 ? _k < _ref3 : _k > _ref3; index = 0 <= _ref3 ? ++_k : --_k) {
            if (!($scope.application.member_ids[index] === memberId)) {
              continue;
            }
            $scope.application.member_ids.splice(index, 1);
            break;
          }
          for (index = _l = 0, _ref4 = $scope.application.root_ids.length; 0 <= _ref4 ? _l < _ref4 : _l > _ref4; index = 0 <= _ref4 ? ++_l : --_l) {
            if (!($scope.application.root_ids[index] === memberId)) {
              continue;
            }
            $scope.application.root_ids.splice(index, 1);
            break;
          }
        }
      };
      return $scope.updateAppKey = function() {
        var data;
        NProgress.start();
        data = {
          id: $scope.application.id,
          app_key: true
        };
        return $v.api.application.updateApplication(data).success(function(application) {
          $scope.application.app_key = application.app_key;
          return NProgress.done();
        });
      };
    }
  ]).controller('SettingsUsersController', [
    '$scope', '$injector', 'users', function($scope, $injector, users) {
      var $state, $stateParams, $v, $validator;
      $v = $injector.get('$v');
      $state = $injector.get('$state');
      $stateParams = $injector.get('$stateParams');
      $validator = $injector.get('$validator');
      $scope.users = users;
      $scope.currentUser = $v.user;
      $scope.isRoot = $v.user.permission === 1;
      return $scope.removeUser = function(user, $event) {
        $event.preventDefault();
        return $v.alert.confirm("Do you want to delete the user " + user.name + "<" + user.email + ">?", function(result) {
          if (!result) {
            return;
          }
          NProgress.start();
          return $v.api.user.removeUser(user.id).success(function() {
            return $state.go($state.current, $stateParams, {
              reload: true
            });
          });
        });
      };
    }
  ]).controller('SettingsNewUserController', [
    '$scope', '$injector', function($scope, $injector) {
      var $state, $v, $validator;
      $v = $injector.get('$v');
      $validator = $injector.get('$validator');
      $state = $injector.get('$state');
      $scope.mode = 'new';
      $scope.user = {
        email: ''
      };
      $scope.modal = {
        autoShow: true,
        hide: function() {},
        hiddenCallback: function() {
          return $state.go('v.settings-users', null, {
            reload: true
          });
        }
      };
      return $scope.submit = function() {
        return $validator.validate($scope, 'user').success(function() {
          NProgress.start();
          return $v.api.user.inviteUser($scope.user.email).success(function() {
            return $scope.modal.hide();
          });
        });
      };
    }
  ]).controller('SettingsUserController', [
    '$scope', '$injector', 'user', function($scope, $injector, user) {
      var $state, $v, $validator;
      $v = $injector.get('$v');
      $validator = $injector.get('$validator');
      $state = $injector.get('$state');
      $scope.mode = 'edit';
      $scope.user = user;
      $scope.modal = {
        autoShow: true,
        hide: function() {},
        hiddenCallback: function() {
          return $state.go('v.settings-users', null, {
            reload: true
          });
        }
      };
      return $scope.submit = function() {
        return $validator.validate($scope, 'user').success(function() {
          NProgress.start();
          return $v.api.user.updateUser($scope.user).success(function() {
            return $scope.modal.hide();
          });
        });
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('v.directive', []).directive('vFocus', function() {
    return {
      restrict: 'A',
      link: function(scope, element) {
        return $(element).select();
      }
    };
  }).directive('vEnter', function() {
    return {

      /*
      Run the AngularJS expression when pressed `Enter`.
       */
      restrict: 'A',
      link: function(scope, element, attrs) {
        return element.bind('keydown keypress', function(e) {
          if (e.which !== 13) {
            return;
          }
          e.preventDefault();
          return scope.$apply(function() {
            return scope.$eval(attrs.vEnter, {
              $event: e
            });
          });
        });
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
  }).directive('vConfirm', [
    '$injector', function($injector) {

      /*
      v-confirm="$rootScope.$confirmModal"
       */
      var $timeout;
      $timeout = $injector.get('$timeout');
      return {
        restrict: 'A',
        scope: {
          modal: '=vConfirm'
        },
        replace: true,
        templateUrl: '/views/modal/confirm.html',
        link: function(scope, element) {
          var confirmed;
          confirmed = false;
          scope.$watch('modal.isShow', function(newValue, oldValue) {
            if (newValue === oldValue) {
              return;
            }
            if (newValue) {
              $(element).modal('show');
              return confirmed = false;
            }
          });
          scope.confirmed = function() {
            confirmed = true;
            return $timeout(function() {
              return $(element).modal('hide');
            });
          };
          $(element).on('shown.bs.modal', function() {
            return $(element).find('[type=submit]').focus();
          });
          return $(element).on('hidden.bs.modal', function() {
            return scope.$apply(function() {
              scope.modal.isShow = false;
              return scope.modal.callback(confirmed);
            });
          });
        }
      };
    }
  ]).directive('vPager', function() {
    return {
      restrict: 'A',
      scope: {
        pageList: '=vPager',
        urlTemplate: '@pagerUrlTemplate'
      },
      replace: true,
      template: "<ul ng-if=\"pageList.total > 0\" class=\"pagination pagination-sm\">\n    <li ng-class=\"{disabled: !links.previous.enable}\">\n        <a ng-href=\"{{ links.previous.url }}\">&laquo;</a>\n    </li>\n    <li ng-repeat='item in links.numbers'\n        ng-if='item.show'\n        ng-class='{active: item.isCurrent}'>\n        <a ng-href=\"{{ item.url }}\">{{ item.pageNumber }}</a>\n    </li>\n    <li ng-class=\"{disabled: !links.next.enable}\">\n        <a ng-href=\"{{ links.next.url }}\">&raquo;</a>\n    </li>\n</ul>",
      link: function(scope) {
        var index, _i, _ref, _ref1, _results;
        scope.links = {
          previous: {
            enable: scope.pageList.has_previous_page,
            url: scope.urlTemplate.replace('#{index}', scope.pageList.index - 1)
          },
          numbers: [],
          next: {
            enable: scope.pageList.has_next_page,
            url: scope.urlTemplate.replace('#{index}', scope.pageList.index + 1)
          }
        };
        _results = [];
        for (index = _i = _ref = scope.pageList.index - 3, _ref1 = scope.pageList.index + 3; _i <= _ref1; index = _i += 1) {
          _results.push(scope.links.numbers.push({
            show: index >= 0 && index <= scope.pageList.max_index,
            isCurrent: index === scope.pageList.index,
            pageNumber: index + 1,
            url: scope.urlTemplate.replace('#{index}', index)
          }));
        }
        return _results;
      }
    };
  });

}).call(this);

(function() {
  angular.module('v.initial', []).config(function() {
    $.extend($.easing, {
      easeOutExpo: function(x, t, b, c, d) {
        if (t === d) {
          return b + c;
        } else {
          return c * (-Math.pow(2, -10 * t / d) + 1) + b;
        }
      }
    });
    return NProgress.configure({
      showSpinner: false
    });
  });

}).call(this);

(function() {
  angular.module('v', ['v.initial', 'v.router', 'v.directive', 'v.validations']);

}).call(this);

(function() {
  angular.module('v.provider', []).provider('$v', function() {
    var $http, $injector, $rootScope, _ref;
    $injector = null;
    $http = null;
    $rootScope = null;
    this.setupProviders = function(injector) {
      $injector = injector;
      $http = $injector.get('$http');
      $rootScope = $injector.get('$rootScope');
      return $rootScope.$confirmModal = {};
    };
    this.user = (_ref = window.user) != null ? _ref : {};
    this.user.isLogin = this.user.id != null;
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
      },
      confirm: function(message, callback) {
        $rootScope.$confirmModal.message = message;
        $rootScope.$confirmModal.callback = callback;
        return $rootScope.$confirmModal.isShow = true;
      }
    };
    this.http = (function(_this) {
      return function(args) {
        return $http(args).error(function() {
          $.av.pop({
            title: 'Server Error',
            message: 'Please try again or refresh this page.',
            template: 'error',
            expire: 3000
          });
          return NProgress.done();
        });
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
      log: {
        getLogs: (function(_this) {
          return function(applicationId, index, keyword) {
            if (applicationId == null) {
              applicationId = 0;
            }
            if (index == null) {
              index = 0;
            }
            return _this.http({
              method: 'get',
              url: "/applications/" + applicationId + "/logs",
              params: {
                index: index,
                keyword: keyword
              }
            });
          };
        })(this),
        getLog: (function(_this) {
          return function(applicationId, logId) {
            return _this.http({
              method: 'get',
              url: "/applications/" + applicationId + "/logs/" + logId
            });
          };
        })(this)
      },
      user: {
        getUsers: (function(_this) {
          return function(index) {
            if (index == null) {
              index = 0;
            }
            return _this.http({
              method: 'get',
              url: '/settings/users',
              params: {
                index: index
              }
            });
          };
        })(this),
        getUser: (function(_this) {
          return function(userId) {
            return _this.http({
              method: 'get',
              url: "/settings/users/" + userId
            });
          };
        })(this),
        inviteUser: (function(_this) {
          return function(email) {
            return _this.http({
              method: 'post',
              url: '/settings/users',
              data: {
                email: email
              }
            });
          };
        })(this),
        removeUser: (function(_this) {
          return function(userId) {
            return _this.http({
              method: 'delete',
              url: "/settings/users/" + userId
            });
          };
        })(this),
        updateUser: (function(_this) {
          return function(user) {
            return _this.http({
              method: 'put',
              url: "/settings/users/" + user.id,
              data: user
            });
          };
        })(this)
      },
      application: {
        getApplications: (function(_this) {
          return function(index, all) {
            if (index == null) {
              index = 0;
            }
            if (all == null) {
              all = false;
            }
            return _this.http({
              method: 'get',
              url: '/settings/applications',
              params: {
                index: index,
                all: all
              }
            });
          };
        })(this),
        addApplicationMember: (function(_this) {
          return function(applicationId, email) {
            return _this.http({
              method: 'post',
              url: "/settings/applications/" + applicationId + "/members",
              data: {
                email: email
              }
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
        views: {
          content: {
            controller: 'IndexController'
          }
        }
      });
      $stateProvider.state('v.login', {
        url: '/login',
        resolve: {
          title: function() {
            return 'Login - ';
          }
        },
        views: {
          content: {
            templateUrl: '/views/login.html',
            controller: 'LoginController'
          }
        }
      });
      $stateProvider.state('v.log-default', {
        url: '/applications',
        resolve: {
          title: function() {
            return 'Logs - ';
          },
          applications: [
            '$v', function($v) {
              return $v.api.application.getApplications(0, true).then(function(response) {
                return response.data;
              });
            }
          ],
          logs: [
            '$v', function($v) {
              return $v.api.log.getLogs().then(function(response) {
                return response.data;
              });
            }
          ]
        },
        views: {
          content: {
            templateUrl: '/views/log/list.html',
            controller: 'LogsController'
          }
        }
      });
      $stateProvider.state('v.log-list', {
        url: '/applications/:applicationId/logs?index?keyword',
        resolve: {
          title: function() {
            return 'Logs - ';
          },
          applications: [
            '$v', function($v) {
              return $v.api.application.getApplications(0, true).then(function(response) {
                return response.data;
              });
            }
          ],
          logs: [
            '$v', '$stateParams', function($v, $stateParams) {
              return $v.api.log.getLogs($stateParams.applicationId, $stateParams.index, $stateParams.keyword).then(function(response) {
                return response.data;
              });
            }
          ]
        },
        views: {
          content: {
            templateUrl: '/views/log/list.html',
            controller: 'LogsController'
          }
        }
      });
      $stateProvider.state('v.log-detail', {
        url: '/applications/:applicationId/logs/:logId',
        resolve: {
          title: function() {
            return 'Log - ';
          },
          application: [
            '$v', '$stateParams', function($v, $stateParams) {
              return $v.api.application.getApplication($stateParams.applicationId).then(function(response) {
                return response.data;
              });
            }
          ],
          log: [
            '$v', '$stateParams', function($v, $stateParams) {
              return $v.api.log.getLog($stateParams.applicationId, $stateParams.logId).then(function(response) {
                return response.data;
              });
            }
          ]
        },
        views: {
          content: {
            templateUrl: '/views/log/detail.html',
            controller: 'LogController'
          }
        }
      });
      $stateProvider.state('v.settings', {
        url: '/settings',
        resolve: {
          title: function() {
            return 'Settings - ';
          }
        },
        controller: 'SettingsController'
      });
      $stateProvider.state('v.settings-profile', {
        url: '/settings/profile',
        resolve: {
          title: function() {
            return 'Profile - Settings - ';
          },
          profile: [
            '$v', function($v) {
              return $v.api.settings.getProfile().then(function(response) {
                return response.data;
              });
            }
          ]
        },
        views: {
          menu: {
            templateUrl: '/views/settings/menu.html',
            controller: 'SettingsMenuController'
          },
          content: {
            templateUrl: '/views/settings/profile.html',
            controller: 'SettingsProfileController'
          }
        }
      });
      $stateProvider.state('v.settings-applications', {
        url: '/settings/applications?index',
        resolve: {
          title: function() {
            return 'Applications - Settings - ';
          },
          applications: [
            '$v', '$stateParams', function($v, $stateParams) {
              return $v.api.application.getApplications($stateParams.index).then(function(response) {
                return response.data;
              });
            }
          ]
        },
        views: {
          menu: {
            templateUrl: '/views/settings/menu.html',
            controller: 'SettingsMenuController'
          },
          content: {
            templateUrl: '/views/settings/applications.html',
            controller: 'SettingsApplicationsController'
          }
        }
      });
      $stateProvider.state('v.settings-applications.new', {
        url: '/new',
        resolve: {
          title: function() {
            return 'Applications - Settings - ';
          }
        },
        templateUrl: '/views/modal/application.html',
        controller: 'SettingsNewApplicationController'
      });
      $stateProvider.state('v.settings-applications.detail', {
        url: '/:applicationId',
        resolve: {
          title: function() {
            return 'Application - Settings - ';
          },
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
      $stateProvider.state('v.settings-users', {
        url: '/settings/users?index',
        resolve: {
          title: function() {
            return 'Users - Settings - ';
          },
          users: [
            '$v', '$stateParams', function($v, $stateParams) {
              return $v.api.user.getUsers($stateParams.index).then(function(response) {
                return response.data;
              });
            }
          ]
        },
        views: {
          menu: {
            templateUrl: '/views/settings/menu.html',
            controller: 'SettingsMenuController'
          },
          content: {
            templateUrl: '/views/settings/users.html',
            controller: 'SettingsUsersController'
          }
        }
      });
      $stateProvider.state('v.settings-users.new', {
        url: '/new',
        resolve: {
          title: function() {
            return 'Users - Settings - ';
          }
        },
        templateUrl: '/views/modal/user.html',
        controller: 'SettingsNewUserController'
      });
      return $stateProvider.state('v.settings-users.detail', {
        url: '/:userId',
        resolve: {
          title: function() {
            return 'Users - Settings - ';
          },
          user: [
            '$v', '$stateParams', function($v, $stateParams) {
              return $v.api.user.getUser($stateParams.userId).then(function(response) {
                return response.data;
              });
            }
          ]
        },
        templateUrl: '/views/modal/user.html',
        controller: 'SettingsUserController'
      });
    }
  ]).run([
    '$injector', function($injector) {
      var $rootScope, $state, $stateParams, $v, changeStartEvent, fromStateName, toStateName;
      $rootScope = $injector.get('$rootScope');
      $stateParams = $injector.get('$stateParams');
      $state = $injector.get('$state');
      $v = $injector.get('$v');
      $rootScope.$stateParams = $stateParams;
      $rootScope.$state = $state;
      changeStartEvent = null;
      fromStateName = null;
      toStateName = null;
      $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState) {
        changeStartEvent = window.event;
        fromStateName = fromState.name;
        toStateName = toState.name;
        return NProgress.start();
      });
      $rootScope.$on('$stateChangeSuccess', function(event, toState) {
        NProgress.done();
        if (!$v.user.isLogin && toState.name !== 'v.login') {
          return $state.go('v.login');
        }
      });
      $rootScope.$on('$stateChangeError', function(event, toState) {
        NProgress.done();
        if (!$v.user.isLogin && toState.name !== 'v.login') {
          return $state.go('v.login');
        }
      });
      return $rootScope.$on('$viewContentLoaded', function() {
        if ((changeStartEvent != null ? changeStartEvent.type : void 0) === 'popstate') {
          return;
        }
        if ((fromStateName != null) && (toStateName != null)) {
          if (fromStateName.replace(toStateName, '').indexOf('.') === 0) {
            return;
          }
          if (toStateName.replace(fromStateName, '').indexOf('.') === 0) {
            return;
          }
        }
        return window.scrollTo(0, 0);
      });
    }
  ]);

}).call(this);

(function() {
  angular.module('v.validations', ['validator']).config([
    '$validatorProvider', function($validatorProvider) {
      $validatorProvider.register('required', {
        validator: /.+/,
        error: 'This field is required.'
      });
      return $validatorProvider.register('email', {
        validator: /(^$)|(^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$)/,
        error: 'This field should be the email.'
      });
    }
  ]);

}).call(this);
