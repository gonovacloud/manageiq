NOVAHawk.angular.app.controller('vmCloudDetachFormController', ['$scope', 'vmCloudDetachFormId', 'miqService', function($scope, vmCloudDetachFormId, miqService) {
  $scope.vmCloudModel = { name: '' };
  $scope.formId = vmCloudDetachFormId;
  $scope.afterGet = false;
  $scope.modelCopy = angular.copy( $scope.vmCloudModel );

  NOVAHawk.angular.scope = $scope;

  $scope.submitClicked = function() {
    miqService.sparkleOn();
    var url = '/vm_cloud/detach_volume/' + vmCloudDetachFormId + '?button=detach';
    miqService.miqAjaxButton(url, true);
  };

  $scope.cancelClicked = function() {
    miqService.sparkleOn();
    var url = '/vm_cloud/detach_volume/' + vmCloudDetachFormId + '?button=cancel';
    miqService.miqAjaxButton(url);
  };

  $scope.resetClicked = function() {
    $scope.vmCloudModel = angular.copy( $scope.modelCopy );
    $scope.angularForm.$setPristine(true);
    miqService.miqFlash("warn", "All changes have been reset");
  };
}]);
