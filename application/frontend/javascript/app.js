(function() {
  angular.module('v.directive', []);

}).call(this);

(function() {
  angular.module('v', ['v.router', 'v.directive']);

}).call(this);

(function() {
  angular.module('v.provider', []).provider('$v', function() {
    this.user = window.user;
    this.$get = [
      '$injector', (function(_this) {
        return function($injector) {
          return {
            user: _this.user
          };
        };
      })(this)
    ];
  });

}).call(this);

(function() {
  angular.module('v.router', ['v.provider']);

}).call(this);
