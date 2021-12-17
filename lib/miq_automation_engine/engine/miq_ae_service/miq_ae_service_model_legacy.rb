module MiqAeMethodService
  module MiqAeServiceModelLegacy
    # Alias model names do not create deprecation warnings
    ALIAS_MODEL_NAMES = {
      'ems' => 'ExtManagementSystem'
    }

    # Legacy model names create deprecation warnings
    LEGACY_MODEL_NAMES = {
      # Amazon
      'auth_key_pair_amazon'                         => 'NOVAHawk_Providers_Amazon_CloudManager_AuthKeyPair',
      'availability_zone_amazon'                     => 'NOVAHawk_Providers_Amazon_CloudManager_AvailabilityZone',
      'cloud_volume_amazon'                          => 'NOVAHawk_Providers_Amazon_CloudManager_CloudVolume',
      'cloud_volume_snapshot_amazon'                 => 'NOVAHawk_Providers_Amazon_CloudManager_CloudVolumeSnapshot',
      'flavor_amazon'                                => 'NOVAHawk_Providers_Amazon_CloudManager_Flavor',
      'floating_ip_amazon'                           => 'NOVAHawk_Providers_Amazon_NetworkManager_FloatingIp',
      'orchestration_stack_amazon'                   => 'NOVAHawk_Providers_Amazon_CloudManager_OrchestrationStack',
      'miq_provision_amazon'                         => 'NOVAHawk_Providers_Amazon_CloudManager_Provision',
      'security_group_amazon'                        => 'NOVAHawk_Providers_Amazon_NetworkManager_SecurityGroup',
      'template_amazon'                              => 'NOVAHawk_Providers_Amazon_CloudManager_Template',
      'vm_amazon'                                    => 'NOVAHawk_Providers_Amazon_CloudManager_Vm',
      'ems_amazon'                                   => 'NOVAHawk_Providers_Amazon_CloudManager',
      # Cloud
      'auth_key_pair_cloud'                          => 'NOVAHawk_Providers_CloudManager_AuthKeyPair',
      'miq_provision_cloud'                          => 'NOVAHawk_Providers_CloudManager_Provision',
      'template_cloud'                               => 'NOVAHawk_Providers_CloudManager_Template',
      'vm_cloud'                                     => 'NOVAHawk_Providers_CloudManager_Vm',
      'ems_cloud'                                    => 'NOVAHawk_Providers_CloudManager',
      # Foreman
      'configuration_profile_foreman'                => 'NOVAHawk_Providers_Foreman_ConfigurationManager_ConfigurationProfile',
      'configured_system_foreman'                    => 'NOVAHawk_Providers_Foreman_ConfigurationManager_ConfiguredSystem',
      'miq_provision_task_configured_system_foreman' => 'NOVAHawk_Providers_Foreman_ConfigurationManager_ProvisionTask',
      'configuration_manager_foreman'                => 'NOVAHawk_Providers_Foreman_ConfigurationManager',
      'provider_foreman'                             => 'NOVAHawk_Providers_Foreman_Provider',
      'provisioning_manager_foreman'                 => 'NOVAHawk_Providers_Foreman_ProvisioningManager',
      # Infra
      'template_infra'                               => 'NOVAHawk_Providers_InfraManager_Template',
      'vm_infra'                                     => 'NOVAHawk_Providers_InfraManager_Vm',
      'ems_infra'                                    => 'NOVAHawk_Providers_InfraManager',
      # Microsoft
      'host_microsoft'                               => 'NOVAHawk_Providers_Microsoft_InfraManager_Host',
      'miq_provision_microsoft'                      => 'NOVAHawk_Providers_Microsoft_InfraManager_Provision',
      'template_microsoft'                           => 'NOVAHawk_Providers_Microsoft_InfraManager_Template',
      'vm_microsoft'                                 => 'NOVAHawk_Providers_Microsoft_InfraManager_Vm',
      'ems_microsoft'                                => 'NOVAHawk_Providers_Microsoft_InfraManager',
      # Openstack
      'auth_key_pair_openstack'                      => 'NOVAHawk_Providers_Openstack_CloudManager_AuthKeyPair',
      'availability_zone_openstack'                  => 'NOVAHawk_Providers_Openstack_CloudManager_AvailabilityZone',
      'availability_zone_openstack_null'             => 'NOVAHawk_Providers_Openstack_CloudManager_AvailabilityZoneNull',
      'cloud_resource_quota_openstack'               => 'NOVAHawk_Providers_Openstack_CloudManager_CloudResourceQuota',
      'cloud_volume_openstack'                       => 'NOVAHawk_Providers_Openstack_CloudManager_CloudVolume',
      'cloud_volume_snapshot_openstack'              => 'NOVAHawk_Providers_Openstack_CloudManager_CloudVolumeSnapshot',
      'flavor_openstack'                             => 'NOVAHawk_Providers_Openstack_CloudManager_Flavor',
      'floating_ip_openstack'                        => 'NOVAHawk_Providers_Openstack_NetworkManager_FloatingIp',
      'orchestration_stack_openstack'                => 'NOVAHawk_Providers_Openstack_CloudManager_OrchestrationStack',
      'miq_provision_openstack'                      => 'NOVAHawk_Providers_Openstack_CloudManager_Provision',
      'security_group_openstack'                     => 'NOVAHawk_Providers_Openstack_NetworkManager_SecurityGroup',
      'template_openstack'                           => 'NOVAHawk_Providers_Openstack_CloudManager_Template',
      'vm_openstack'                                 => 'NOVAHawk_Providers_Openstack_CloudManager_Vm',
      'ems_openstack'                                => 'NOVAHawk_Providers_Openstack_CloudManager',
      # Openstack Infra
      'ems_cluster_openstack_infra'                  => 'NOVAHawk_Providers_Openstack_InfraManager_EmsCluster',
      'host_openstack_infra'                         => 'NOVAHawk_Providers_Openstack_InfraManager_Host',
      'orchestration_stack_openstack_infra'          => 'NOVAHawk_Providers_Openstack_InfraManager_OrchestrationStack',
      'ems_openstack_infra'                          => 'NOVAHawk_Providers_Openstack_InfraManager',
      # Red Hat
      'host_redhat'                                  => 'NOVAHawk_Providers_Redhat_InfraManager_Host',
      'miq_provision_redhat'                         => 'NOVAHawk_Providers_Redhat_InfraManager_Provision',
      'miq_provision_redhat_via_iso'                 => 'NOVAHawk_Providers_Redhat_InfraManager_ProvisionViaIso',
      'miq_provision_redhat_via_pxe'                 => 'NOVAHawk_Providers_Redhat_InfraManager_ProvisionViaPxe',
      'template_redhat'                              => 'NOVAHawk_Providers_Redhat_InfraManager_Template',
      'vm_redhat'                                    => 'NOVAHawk_Providers_Redhat_InfraManager_Vm',
      'ems_redhat'                                   => 'NOVAHawk_Providers_Redhat_InfraManager',
      # VMware
      'host_vmware'                                  => 'NOVAHawk_Providers_Vmware_InfraManager_Host',
      'host_vmware_esx'                              => 'NOVAHawk_Providers_Vmware_InfraManager_HostEsx',
      'miq_provision_vmware'                         => 'NOVAHawk_Providers_Vmware_InfraManager_Provision',
      'miq_provision_vmware_via_pxe'                 => 'NOVAHawk_Providers_Vmware_InfraManager_ProvisionViaPxe',
      'template_vmware'                              => 'NOVAHawk_Providers_Vmware_InfraManager_Template',
      'vm_vmware'                                    => 'NOVAHawk_Providers_Vmware_InfraManager_Vm',
      'ems_vmware'                                   => 'NOVAHawk_Providers_Vmware_InfraManager',
      # Others
      'configuration_manager'                        => 'NOVAHawk_Providers_ConfigurationManager',
      'provisioning_manager'                         => 'NOVAHawk_Providers_ProvisioningManager'
    }

    def service_model_lookup(model_name)
      converted_name = model_name.to_s.underscore
      new_model_name = LEGACY_MODEL_NAMES[converted_name]
      if new_model_name
        "MiqAeMethodService::MiqAeService#{new_model_name}".constantize.tap do
          MiqAeMethodService::Deprecation.deprecation_warning(model_name, new_model_name)
        end
      else
        new_model_name = ALIAS_MODEL_NAMES[converted_name] || converted_name.camelize
        "MiqAeMethodService::MiqAeService#{new_model_name}".constantize
      end
    end
  end
end
