class FixRedhatNamespace < ActiveRecord::Migration
  include MigrationHelper

  NAME_MAP = Hash[*%w(
    NOVAHawk::Providers::Redhat::CloudManager
    NOVAHawk::Providers::Redhat::InfraManager
    NOVAHawk::Providers::Redhat::CloudManager::EventCatcher
    NOVAHawk::Providers::Redhat::InfraManager::EventCatcher
    NOVAHawk::Providers::Redhat::CloudManager::EventCatcher::Runner
    NOVAHawk::Providers::Redhat::InfraManager::EventCatcher::Runner
    NOVAHawk::Providers::Redhat::CloudManager::MetricsCollectorWorker
    NOVAHawk::Providers::Redhat::InfraManager::MetricsCollectorWorker
    NOVAHawk::Providers::Redhat::CloudManager::MetricsCollectorWorker::Runner
    NOVAHawk::Providers::Redhat::InfraManager::MetricsCollectorWorker::Runner
    NOVAHawk::Providers::Redhat::CloudManager::RefreshWorker
    NOVAHawk::Providers::Redhat::InfraManager::RefreshWorker
    NOVAHawk::Providers::Redhat::CloudManager::RefreshWorker::Runner
    NOVAHawk::Providers::Redhat::InfraManager::RefreshWorker::Runner
    NOVAHawk::Providers::Redhat::CloudManager::Template
    NOVAHawk::Providers::Redhat::InfraManager::Template
    NOVAHawk::Providers::Redhat::CloudManager::Vm
    NOVAHawk::Providers::Redhat::InfraManager::Vm

    HostRedhat                             NOVAHawk::Providers::Redhat::InfraManager::Host
  )]

  def change
    rename_class_references(NAME_MAP)
  end
end
