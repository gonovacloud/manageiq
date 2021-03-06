NOVAHawk.angular.app.controller('vmCloudAttachFormController', ['$scope', 'vmCloudAttachFormId', 'miqService', function($scope, vmCloudAttachFormId, miqService) {
  $scope.vmCloudModel = { name: '' };
  $scope.formId = vmCloudAttachFormId;
  $scope.afterGet = false;
  $scope.modelCopy = angular.copy( $scope.vmCloudModel );

  NOVAHawk.angular.scope = $scope;

  $scope.submitClicked = function() {
    miqService.sparkleOn();
    var url = '/vm_cloud/attach_volume/' + vmCloudAttachFormId + '?button=attach';
    miqService.miqAjaxButton(url, true);
  };

  $scope.cancelClicked = function() {
    miqService.sparkleOn();
    var url = '/vm_cloud/attach_volume/' + vmCloudAttachFormId + '?button=cancel';
    miqService.miqAjaxButton(url);
  };

  $scope.resetClicked = function() {
    $scope.vmCloudModel = angular.copy( $scope.modelCopy );
    $scope.angularForm.$setPristine(true);
    miqService.miqFlash("warn", "All changes have been reset");
  };
}]);
