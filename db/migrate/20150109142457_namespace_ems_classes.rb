class NamespaceEmsClasses < ActiveRecord::Migration
  include MigrationHelper

  NAME_MAP = Hash[*%w(
    EmsCloud                               NOVAHawk::Providers::CloudManager
    HostCloud                              NOVAHawk::Providers::CloudManager::Host
    TemplateCloud                          NOVAHawk::Providers::CloudManager::Template
    VmCloud                                NOVAHawk::Providers::CloudManager::Vm

    EmsInfra                               NOVAHawk::Providers::InfraManager
    HostInfra                              NOVAHawk::Providers::InfraManager::Host
    TemplateInfra                          NOVAHawk::Providers::InfraManager::Template
    VmInfra                                NOVAHawk::Providers::InfraManager::Vm

    EmsVmware                              NOVAHawk::Providers::Vmware::InfraManager
    MiqEventCatcherVmware                  NOVAHawk::Providers::Vmware::InfraManager::EventCatcher
    EventCatcherVmware                     NOVAHawk::Providers::Vmware::InfraManager::EventCatcher::Runner
    HostVmware                             NOVAHawk::Providers::Vmware::InfraManager::Host
    HostVmwareEsx                          NOVAHawk::Providers::Vmware::InfraManager::HostEsx
    MiqEmsMetricsCollectorWorkerVmware     NOVAHawk::Providers::Vmware::InfraManager::MetricsCollectorWorker
    EmsMetricsCollectorWorkerVmware        NOVAHawk::Providers::Vmware::InfraManager::MetricsCollectorWorker::Runner
    MiqEmsRefreshWorkerVmware              NOVAHawk::Providers::Vmware::InfraManager::RefreshWorker
    EmsRefreshWorkerVmware                 NOVAHawk::Providers::Vmware::InfraManager::RefreshWorker::Runner
    TemplateVmware                         NOVAHawk::Providers::Vmware::InfraManager::Template
    VmVmware                               NOVAHawk::Providers::Vmware::InfraManager::Vm
  )]

  def change
    rename_class_references(NAME_MAP)
  end
end
