NOVAHawk.angular.app.directive('autoFocus', ['$timeout', function($timeout) {
  return {
    require: 'ngModel',
    link: function (scope, elem, attr, ctrl) {
      scope['form_focus_' + ctrl.$name] = elem[0];

      scope.$watch(function() { return elem.is(':visible') }, function() {
        if (attr.autoFocus == "" || attr.autoFocus == "proactiveFocus") {
          angular.element(scope['form_focus_' + ctrl.$name]).focus();
          if (!angular.element(scope['form_focus_' + ctrl.$name]).is(":focus")) {
            NOVAHawk.qe.autofocus += 1;
            $timeout(function () {
              angular.element(scope['form_focus_' + ctrl.$name]).focus();
              NOVAHawk.qe.autofocus -= 1;
            }, 1000);
          }
        }
      });

      scope.$on('reactiveFocus', function(_e) {
        if (!angular.element(scope['form_focus_' + ctrl.$name]).is(":focus")) {
          NOVAHawk.qe.autofocus += 1;
          $timeout(function() {
            angular.element(scope['form_focus_' + ctrl.$name]).focus();
            NOVAHawk.qe.autofocus -= 1;
          }, 0);
        };
      });
    }
  }
}]);
