NOVAHawk.angular.app.controller('cloudSubnetFormController', ['$http', '$scope', 'cloudSubnetFormId', 'miqService', function($http, $scope, cloudSubnetFormId, miqService) {
  $scope.cloudSubnetModel = { name: '', ems_id: '', cloud_tenant_id: '', network_id: '' };
  $scope.formId = cloudSubnetFormId;
  $scope.afterGet = false;
  $scope.modelCopy = angular.copy( $scope.cloudSubnetModel );
  $scope.model = "cloudSubnetModel";

  NOVAHawk.angular.scope = $scope;

  if (cloudSubnetFormId == 'new') {
    $scope.cloudSubnetModel.name = "";
    $scope.cloudSubnetModel.dhcp_enabled = true;
    $scope.cloudSubnetModel.network_protocol = '4';
    $scope.newRecord = true;
  } else {
    miqService.sparkleOn();

    $http.get('/cloud_subnet/cloud_subnet_form_fields/' + cloudSubnetFormId).success(function(data) {
      $scope.afterGet = true;
      $scope.cloudSubnetModel.name = data.name;
      $scope.cloudSubnetModel.dhcp_enabled = data.dhcp_enabled;
      $scope.cloudSubnetModel.cidr = data.cidr;
      $scope.cloudSubnetModel.gateway = data.gateway;
      $scope.cloudSubnetModel.network_protocol = data.network_protocol;

      $scope.modelCopy = angular.copy( $scope.cloudSubnetModel );
      miqService.sparkleOff();
    });
  }

  $scope.addClicked = function() {
    var url = 'create/new' + '?button=add';
    miqService.miqAjaxButton(url, $scope.cloudSubnetModel, { complete: false });
  };

  $scope.cancelClicked = function() {
    if (cloudSubnetFormId == 'new') {
      var url = '/cloud_subnet/create/new' + '?button=cancel';
    } else {
      var url = '/cloud_subnet/update/' + cloudSubnetFormId + '?button=cancel';
    }
    miqService.miqAjaxButton(url);
  };

  $scope.saveClicked = function() {
    var url = '/cloud_subnet/update/' + cloudSubnetFormId + '?button=save';
    miqService.miqAjaxButton(url, $scope.cloudSubnetModel, { complete: false });
  };

  $scope.resetClicked = function() {
    $scope.cloudSubnetModel = angular.copy( $scope.modelCopy );
    $scope.angularForm.$setPristine(true);
    miqService.miqFlash("warn", "All changes have been reset");
  };
}]);
