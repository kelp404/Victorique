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


}).call(this);
