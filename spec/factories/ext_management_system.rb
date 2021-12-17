FactoryGirl.define do
  factory :ext_management_system do
    sequence(:name)      { |n| "ems_#{seq_padded_for_sorting(n)}" }
    sequence(:hostname)  { |n| "ems_#{seq_padded_for_sorting(n)}" }
    sequence(:ipaddress) { |n| ip_from_seq(n) }
    guid                 { MiqUUID.new_guid }
    zone                 { Zone.first || FactoryGirl.create(:zone) }
    storage_profiles     { [] }
  end

  # Intermediate classes

  factory :ems_infra,
          :aliases => ["novahawk/providers/infra_manager"],
          :class   => "NOVAHawk::Providers::InfraManager",
          :parent  => :ext_management_system do
  end

  factory :ems_cloud,
          :aliases => ["novahawk/providers/cloud_manager"],
          :class   => "NOVAHawk::Providers::CloudManager",
          :parent  => :ext_management_system do
  end

  factory :ems_network,
          :aliases => ["novahawk/providers/network_manager"],
          :class   => "NOVAHawk::Providers::NetworkManager",
          :parent  => :ext_management_system do
  end

  factory :ems_storage,
          :aliases => ["novahawk/providers/storage_manager"],
          :class   => "NOVAHawk::Providers::StorageManager",
          :parent  => :ext_management_system do
  end

  factory :ems_cinder,
          :aliases => ["novahawk/providers/storage_manager/cinder_manager"],
          :class   => "NOVAHawk::Providers::StorageManager::CinderManager",
          :parent  => :ext_management_system do
  end

  factory :ems_swift,
          :aliases => ["novahawk/providers/storage_manager/swift_manager"],
          :class   => "NOVAHawk::Providers::StorageManager::SwiftManager",
          :parent  => :ext_management_system do
  end

  factory :ems_container,
          :aliases => ["novahawk/providers/container_manager"],
          :class   => "NOVAHawk::Providers::ContainerManager",
          :parent  => :ext_management_system do
  end

  factory :ems_middleware,
          :aliases => ["novahawk/providers/middleware_manager"],
          :class   => "NOVAHawk::Providers::MiddlewareManager",
          :parent  => :ext_management_system do
  end

  factory :configuration_manager,
          :aliases => ["novahawk/providers/configuration_manager"],
          :class   => "NOVAHawk::Providers::ConfigurationManager",
          :parent  => :ext_management_system do
  end

  factory :provisioning_manager,
          :aliases => ["novahawk/providers/provisioning_manager"],
          :class   => "NOVAHawk::Providers::ProvisioningManager",
          :parent  => :ext_management_system do
  end

  # Leaf classes for ems_infra

  factory :ems_vmware,
          :aliases => ["novahawk/providers/vmware/infra_manager"],
          :class   => "NOVAHawk::Providers::Vmware::InfraManager",
          :parent  => :ems_infra do
  end

  factory :ems_vmware_with_authentication,
          :parent => :ems_vmware do
    after(:create) do |x|
      x.authentications << FactoryGirl.create(:authentication)
    end
  end

  factory :ems_microsoft,
          :aliases => ["novahawk/providers/microsoft/infra_manager"],
          :class   => "NOVAHawk::Providers::Microsoft::InfraManager",
          :parent  => :ems_infra do
  end

  factory :ems_microsoft_with_authentication,
          :parent => :ems_microsoft do
    after(:create) do |x|
      x.authentications << FactoryGirl.create(:authentication)
    end
  end

  factory :ems_redhat,
          :aliases => ["novahawk/providers/redhat/infra_manager"],
          :class   => "NOVAHawk::Providers::Redhat::InfraManager",
          :parent  => :ems_infra do
  end

  factory :ems_redhat_with_authentication,
          :parent => :ems_redhat do
    after(:create) do |x|
      x.authentications << FactoryGirl.create(:authentication)
    end
  end

  factory :ems_redhat_with_metrics_authentication,
          :parent => :ems_redhat do
    after(:create) do |x|
      x.authentications << FactoryGirl.create(:authentication_redhat_metric)
    end
  end

  factory :ems_openstack_infra,
          :aliases => ["novahawk/providers/openstack/infra_manager"],
          :class   => "NOVAHawk::Providers::Openstack::InfraManager",
          :parent  => :ems_infra do
  end

  factory :ems_openstack_infra_with_stack,
          :parent => :ems_openstack_infra do
    after :create do |x|
      x.orchestration_stacks << FactoryGirl.create(:orchestration_stack_openstack_infra)
      4.times { x.hosts << FactoryGirl.create(:host_openstack_infra) }
    end
  end

  factory :ems_openstack_infra_with_stack_and_compute_nodes,
          :parent => :ems_openstack_infra do
    after :create do |x|
      x.orchestration_stacks << FactoryGirl.create(:orchestration_stack_openstack_infra)
      x.hosts += [FactoryGirl.create(:host_openstack_infra_compute),
                  FactoryGirl.create(:host_openstack_infra_compute_maintenance)]
    end
  end

  factory :ems_openstack_infra_with_authentication,
          :parent => :ems_openstack_infra do
    after :create do |x|
      x.authentications << FactoryGirl.create(:authentication)
      x.authentications << FactoryGirl.create(:authentication, :authtype => "amqp")
    end
  end

  factory :ems_vmware_cloud,
          :aliases => ["novahawk/providers/vmware/cloud_manager"],
          :class   => "NOVAHawk::Providers::Vmware::CloudManager",
          :parent  => :ems_cloud do
  end

  factory :ems_vmware_cloud_network,
          :aliases => ["novahawk/providers/vmware/network_manager"],
          :class   => "NOVAHawk::Providers::Vmware::NetworkManager",
          :parent  => :ems_cloud do
  end

  # Leaf classes for ems_cloud

  factory :ems_amazon,
          :aliases => ["novahawk/providers/amazon/cloud_manager"],
          :class   => "NOVAHawk::Providers::Amazon::CloudManager",
          :parent  => :ems_cloud do
    provider_region "us-east-1"
  end

  factory :ems_amazon_network,
          :aliases => ["novahawk/providers/amazon/network_manager"],
          :class   => "NOVAHawk::Providers::Amazon::NetworkManager",
          :parent  => :ems_network do
    provider_region "us-east-1"
  end

  factory :ems_amazon_with_authentication,
          :parent => :ems_amazon do
    after(:create) do |x|
      x.authentications << FactoryGirl.create(:authentication)
    end
  end

  factory :ems_amazon_with_cloud_networks,
          :parent => :ems_amazon do
    after(:create) do |x|
      2.times { x.cloud_networks << FactoryGirl.create(:cloud_network_amazon) }
    end
  end

  factory :ems_azure,
          :aliases => ["novahawk/providers/azure/cloud_manager"],
          :class   => "NOVAHawk::Providers::Azure::CloudManager",
          :parent  => :ems_cloud do
  end

  factory :ems_azure_network,
          :aliases => ["novahawk/providers/azure/network_manager"],
          :class   => "NOVAHawk::Providers::Azure::NetworkManager",
          :parent  => :ems_network do
  end

  factory :ems_azure_with_authentication,
          :parent => :ems_azure do
    azure_tenant_id "ABCDEFGHIJABCDEFGHIJ0123456789AB"
    subscription "0123456789ABCDEFGHIJABCDEFGHIJKL"
    after :create do |x|
      x.authentications << FactoryGirl.create(:authentication)
    end
  end

  factory :ems_openstack,
          :aliases => ["novahawk/providers/openstack/cloud_manager"],
          :class   => "NOVAHawk::Providers::Openstack::CloudManager",
          :parent  => :ems_cloud do
  end

  factory :ems_openstack_with_authentication,
          :parent => :ems_openstack do
    after :create do |x|
      x.authentications << FactoryGirl.create(:authentication)
      x.authentications << FactoryGirl.create(:authentication, :authtype => "amqp")
    end
  end

  factory :ems_openstack_network,
          :aliases => ["novahawk/providers/openstack/network_manager"],
          :class   => "NOVAHawk::Providers::Openstack::NetworkManager",
          :parent  => :ems_network do
  end

  factory :ems_nuage_network,
          :aliases => ["novahawk/providers/nuage/network_manager"],
          :class   => "NOVAHawk::Providers::Nuage::NetworkManager",
          :parent  => :ems_network do
  end

  factory :ems_google,
          :aliases => ["novahawk/providers/google/cloud_manager"],
          :class   => "NOVAHawk::Providers::Google::CloudManager",
          :parent  => :ems_cloud do
    provider_region "us-central1"
  end

  factory :ems_google_with_authentication,
          :parent => :ems_google do
    after(:create) do |x|
      x.authentications << FactoryGirl.create(:authentication)
    end
  end

  factory :ems_google_network,
          :aliases => ["novahawk/providers/google/network_manager"],
          :class   => "NOVAHawk::Providers::Google::NetworkManager",
          :parent  => :ems_network do
    provider_region "us-central1"
  end

  # Leaf classes for ems_container

  factory :ems_kubernetes,
          :aliases => ["novahawk/providers/kubernetes/container_manager"],
          :class   => "NOVAHawk::Providers::Kubernetes::ContainerManager",
          :parent  => :ems_container do
  end

  factory :ems_kubernetes_with_authentication_err,
          :parent => :ems_kubernetes do
    after :create do |x|
      x.authentications << FactoryGirl.create(:authentication_status_error)
    end
  end


  factory :ems_openshift,
          :aliases => ["novahawk/providers/openshift/container_manager"],
          :class   => "NOVAHawk::Providers::Openshift::ContainerManager",
          :parent  => :ems_container do
  end

  factory :ems_openshift_enterprise,
          :aliases => ["novahawk/providers/openshift_enterprise/container_manager"],
          :class   => "NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager",
          :parent  => :ems_container do
  end

  # Leaf classes for configuration_manager

  factory :configuration_manager_foreman,
          :aliases => ["novahawk/providers/foreman/configuration_manager"],
          :class   => "NOVAHawk::Providers::Foreman::ConfigurationManager",
          :parent  => :configuration_manager

  factory :configuration_manager_ansible_tower,
          :aliases => ["novahawk/providers/ansible_tower/configuration_manager"],
          :class   => "NOVAHawk::Providers::AnsibleTower::ConfigurationManager",
          :parent  => :configuration_manager

  trait(:provider) do
    after(:build, &:create_provider)
  end

  trait(:configuration_script) do
    after(:create) do |x|
      type = (x.type.split("::")[0..2] + ["ConfigurationManager", "ConfigurationScript"]).join("::")
      x.configuration_scripts << FactoryGirl.create(:configuration_script, :type => type)
    end
  end

  factory :configuration_manager_foreman_with_authentication,
          :parent => :configuration_manager_foreman do
    after :create do |x|
      x.authentications << FactoryGirl.create(:authentication)
    end
  end

  # Leaf classes for provisioning_manager

  factory :provisioning_manager_foreman,
          :aliases => ["novahawk/providers/foreman/provisioning_manager"],
          :class   => "NOVAHawk::Providers::Foreman::ProvisioningManager",
          :parent  => :provisioning_manager do
  end

  factory :provisioning_manager_foreman_with_authentication,
          :parent => :provisioning_manager_foreman do
    after :create do |x|
      x.authentications << FactoryGirl.create(:authentication)
    end
  end

  # Leaf classes for middleware_manager

  factory :ems_hawkular,
          :aliases => ["novahawk/providers/hawkular/middleware_manager"],
          :class   => "NOVAHawk::Providers::Hawkular::MiddlewareManager",
          :parent  => :ems_middleware do
  end
end
