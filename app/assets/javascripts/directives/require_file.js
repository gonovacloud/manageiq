NOVAHawk.angular.app.directive('requireFile', ['$parse', function ($parse) {
  return {
    require: 'ngModel',
    link: function(scope, el, attrs, _ngModel) {
      var modelGetter = $parse(attrs['ngModel']);
      var modelSetter = modelGetter.assign;

      //change event is fired when file is selected
      el.bind('change', function () {
        scope.$apply(function () {
          if (el[0].files[0] && attrs.requireFile && attrs.requireFile === 'handle') {
            modelSetter(scope, el[0].files[0]);
          }
          else {
            var reader = new FileReader();
            reader.onload = function (e) {
              scope.$apply(function () {
                modelSetter(scope, e.target.result);
              });
            };
            if (el[0].files[0]) {
              reader.readAsText(el[0].files[0]);
            }

          }
        });
      });
    }
  }
}]);
