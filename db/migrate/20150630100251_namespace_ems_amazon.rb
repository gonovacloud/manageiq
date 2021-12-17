class NamespaceEmsAmazon < ActiveRecord::Migration
  include MigrationHelper

  NAME_MAP = Hash[*%w(
    AuthKeyPairCloud                           NOVAHawk::Providers::CloudManager::AuthKeyPair

    EmsAmazon                                  NOVAHawk::Providers::Amazon::CloudManager
    AvailabilityZoneAmazon                     NOVAHawk::Providers::Amazon::CloudManager::AvailabilityZone
    CloudVolumeAmazon                          NOVAHawk::Providers::Amazon::CloudManager::CloudVolume
    CloudVolumeSnapshotAmazon                  NOVAHawk::Providers::Amazon::CloudManager::CloudVolumeSnapshot
    MiqEventCatcherAmazon                      NOVAHawk::Providers::Amazon::CloudManager::EventCatcher
    EventCatcherAmazon                         NOVAHawk::Providers::Amazon::CloudManager::EventCatcher::Runner
    FlavorAmazon                               NOVAHawk::Providers::Amazon::CloudManager::Flavor
    FloatingIpAmazon                           NOVAHawk::Providers::Amazon::CloudManager::FloatingIp
    MiqEmsMetricsCollectorWorkerAmazon         NOVAHawk::Providers::Amazon::CloudManager::MetricsCollectorWorker
    EmsMetricsCollectorWorkerAmazon            NOVAHawk::Providers::Amazon::CloudManager::MetricsCollectorWorker::Runner
    OrchestrationStackAmazon                   NOVAHawk::Providers::Amazon::CloudManager::OrchestrationStack
    MiqEmsRefreshWorkerAmazon                  NOVAHawk::Providers::Amazon::CloudManager::RefreshWorker
    EmsRefreshWorkerAmazon                     NOVAHawk::Providers::Amazon::CloudManager::RefreshWorker::Runner
    SecurityGroupAmazon                        NOVAHawk::Providers::Amazon::CloudManager::SecurityGroup
    TemplateAmazon                             NOVAHawk::Providers::Amazon::CloudManager::Template
    VmAmazon                                   NOVAHawk::Providers::Amazon::CloudManager::Vm

    ServiceOrchestration::OptionConverterAmazon
    NOVAHawk::Providers::Amazon::CloudManager::OrchestrationServiceOptionConverter
  )]

  def change
    rename_class_references(NAME_MAP)
  end
end
