NOVAHawk.angular.app = angular.module('NOVAHawk', [
  'ui.bootstrap',
  'ui.codemirror',
  'patternfly',
  'frapontillo.bootstrap-switch',
  'angular.validators',
  'miq.api'
]);
miqHttpInject(NOVAHawk.angular.app);

NOVAHawk.angular.rxSubject = new Rx.Subject();

function miqHttpInject(angular_app) {
  angular_app.config(['$httpProvider', function($httpProvider) {
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = function() {
      return $('meta[name=csrf-token]').attr('content');
    };

    $httpProvider.interceptors.push(['$q', function($q) {
      return {
        responseError: function(err) {
          sendDataWithRx({
            serverError: err,
          });

          console.error('Server returned a non-200 response:', err.status, err.statusText, err);
          return $q.reject(err);
        },
      };
    }]);
  }]);

  return angular_app;
}

function miq_bootstrap(selector, app) {
  app = app || 'NOVAHawk';

  return angular.bootstrap($(selector), [app], { strictDi: true });
}

function miqCallAngular(data) {
  NOVAHawk.angular.scope.$apply(function() {
    NOVAHawk.angular.scope[data.name].apply(NOVAHawk.angular.scope, data.args);
  });
}

function sendDataWithRx(data) {
  NOVAHawk.angular.rxSubject.onNext(data);
}
