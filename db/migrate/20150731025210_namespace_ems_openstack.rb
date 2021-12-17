class NamespaceEmsOpenstack < ActiveRecord::Migration
  include MigrationHelper

  NAME_MAP = Hash[*%w(
    ProviderOpenstack                       NOVAHawk::Providers::Openstack::Provider

    EmsOpenstack                            NOVAHawk::Providers::Openstack::CloudManager
    AuthKeyPairOpenstack                    NOVAHawk::Providers::Openstack::CloudManager::AuthKeyPair
    AvailabilityZoneOpenstack               NOVAHawk::Providers::Openstack::CloudManager::AvailabilityZone
    CloudResourceQuotaOpenstack             NOVAHawk::Providers::Openstack::CloudManager::CloudResourceQuota
    CloudTenantOpenstack                    NOVAHawk::Providers::Openstack::CloudManager::CloudTenant
    CloudVolumeOpenstack                    NOVAHawk::Providers::Openstack::CloudManager::CloudVolume
    CloudVolumeSnapshotOpenstack            NOVAHawk::Providers::Openstack::CloudManager::CloudVolumeSnapshot
    MiqEventCatcherOpenstack                NOVAHawk::Providers::Openstack::CloudManager::EventCatcher
    EventCatcherOpenstack                   NOVAHawk::Providers::Openstack::CloudManager::EventCatcher::Runner
    FlavorOpenstack                         NOVAHawk::Providers::Openstack::CloudManager::Flavor
    FloatingIpOpenstack                     NOVAHawk::Providers::Openstack::CloudManager::FloatingIp
    MiqEmsMetricsCollectorWorkerOpenstack   NOVAHawk::Providers::Openstack::CloudManager::MetricsCollectorWorker
    EmsMetricsCollectorWorkerOpenstack      NOVAHawk::Providers::Openstack::CloudManager::MetricsCollectorWorker::Runner
    OrchestrationStackOpenstack             NOVAHawk::Providers::Openstack::CloudManager::OrchestrationStack
    MiqEmsRefreshWorkerOpenstack            NOVAHawk::Providers::Openstack::CloudManager::RefreshWorker
    EmsRefreshWorkerOpenstack               NOVAHawk::Providers::Openstack::CloudManager::RefreshWorker::Runner
    SecurityGroupOpenstack                  NOVAHawk::Providers::Openstack::CloudManager::SecurityGroup
    TemplateOpenstack                       NOVAHawk::Providers::Openstack::CloudManager::Template
    VmOpenstack                             NOVAHawk::Providers::Openstack::CloudManager::Vm

    ServiceOrchestration::OptionConverterOpenstack
    NOVAHawk::Providers::Openstack::CloudManager::OrchestrationServiceOptionConverter

    EmsOpenstackInfra                       NOVAHawk::Providers::Openstack::InfraManager
    AuthKeyPairOpenstackInfra               NOVAHawk::Providers::Openstack::InfraManager::AuthKeyPair
    EmsClusterOpenstackInfra                NOVAHawk::Providers::Openstack::InfraManager::EmsCluster
    MiqEventCatcherOpenstackInfra           NOVAHawk::Providers::Openstack::InfraManager::EventCatcher
    EventCatcherOpenstackInfra              NOVAHawk::Providers::Openstack::InfraManager::EventCatcher::Runner
    HostOpenstackInfra                      NOVAHawk::Providers::Openstack::InfraManager::Host
    HostServiceGroupOpenstack               NOVAHawk::Providers::Openstack::InfraManager::HostServiceGroup
    MiqEmsMetricsCollectorWorkerOpenstackInfra      NOVAHawk::Providers::Openstack::InfraManager::MetricsCollectorWorker
    EmsMetricsCollectorWorkerOpenstackInfra NOVAHawk::Providers::Openstack::InfraManager::MetricsCollectorWorker::Runner
    OrchestrationStackOpenstackInfra        NOVAHawk::Providers::Openstack::InfraManager::OrchestrationStack
    MiqEmsRefreshWorkerOpenstackInfra       NOVAHawk::Providers::Openstack::InfraManager::RefreshWorker
    EmsRefreshWorkerOpenstackInfra          NOVAHawk::Providers::Openstack::InfraManager::RefreshWorker::Runner
  )]

  def change
    say_with_time "Rename class references for Openstack and OpenstackInfra" do
      rename_class_references(NAME_MAP)
    end
  end
end
