class NamespaceEmsRedhat < ActiveRecord::Migration
  include MigrationHelper

  NAME_MAP = Hash[*%w(
    EmsRedhat                                  NOVAHawk::Providers::Redhat::CloudManager
    AvailabilityZoneRedhat                     NOVAHawk::Providers::Redhat::CloudManager::AvailabilityZone
    CloudVolumeRedhat                          NOVAHawk::Providers::Redhat::CloudManager::CloudVolume
    CloudVolumeSnapshotRedhat                  NOVAHawk::Providers::Redhat::CloudManager::CloudVolumeSnapshot
    MiqEventCatcherRedhat                      NOVAHawk::Providers::Redhat::CloudManager::EventCatcher
    EventCatcherRedhat                         NOVAHawk::Providers::Redhat::CloudManager::EventCatcher::Runner
    FlavorRedhat                               NOVAHawk::Providers::Redhat::CloudManager::Flavor
    FloatingIpRedhat                           NOVAHawk::Providers::Redhat::CloudManager::FloatingIp
    MiqEmsMetricsCollectorWorkerRedhat         NOVAHawk::Providers::Redhat::CloudManager::MetricsCollectorWorker
    EmsMetricsCollectorWorkerRedhat            NOVAHawk::Providers::Redhat::CloudManager::MetricsCollectorWorker::Runner
    OrchestrationStackRedhat                   NOVAHawk::Providers::Redhat::CloudManager::OrchestrationStack
    MiqEmsRefreshWorkerRedhat                  NOVAHawk::Providers::Redhat::CloudManager::RefreshWorker
    EmsRefreshWorkerRedhat                     NOVAHawk::Providers::Redhat::CloudManager::RefreshWorker::Runner
    SecurityGroupRedhat                        NOVAHawk::Providers::Redhat::CloudManager::SecurityGroup
    TemplateRedhat                             NOVAHawk::Providers::Redhat::CloudManager::Template
    VmRedhat                                   NOVAHawk::Providers::Redhat::CloudManager::Vm
  )]

  def change
    rename_class_references(NAME_MAP)
  end
end
