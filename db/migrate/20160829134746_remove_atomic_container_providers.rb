class RemoveAtomicContainerProviders < ActiveRecord::Migration[5.0]
  include MigrationHelper

  NAME_MAP = Hash[*%w(
    NOVAHawk::Providers::Atomic::ContainerManager                                 NOVAHawk::Providers::Openshift::ContainerManager
    NOVAHawk::Providers::Atomic::ContainerManager::EventCatcher                   NOVAHawk::Providers::Openshift::ContainerManager::EventCatcher
    NOVAHawk::Providers::Atomic::ContainerManager::EventCatcher::Runner           NOVAHawk::Providers::Openshift::ContainerManager::EventCatcher::Runner
    NOVAHawk::Providers::Atomic::ContainerManager::EventParser                    NOVAHawk::Providers::Openshift::ContainerManager::EventParser
    NOVAHawk::Providers::Atomic::ContainerManager::MetricsCollectorWorker         NOVAHawk::Providers::Openshift::ContainerManager::MetricsCollectorWorker
    NOVAHawk::Providers::Atomic::ContainerManager::MetricsCollectorWorker::Runner NOVAHawk::Providers::Openshift::ContainerManager::MetricsCollectorWorker::Runner
    NOVAHawk::Providers::Atomic::ContainerManager::RefreshParser                  NOVAHawk::Providers::Openshift::ContainerManager::RefreshParser
    NOVAHawk::Providers::Atomic::ContainerManager::RefreshWorker                  NOVAHawk::Providers::Openshift::ContainerManager::RefreshWorker
    NOVAHawk::Providers::Atomic::ContainerManager::RefreshWorker::Runner          NOVAHawk::Providers::Openshift::ContainerManager::RefreshWorker::Runner
    NOVAHawk::Providers::Atomic::ContainerManager::Refresher                      NOVAHawk::Providers::Openshift::ContainerManager::Refresher

    NOVAHawk::Providers::AtomicEnterprise::ContainerManager                                 NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager
    NOVAHawk::Providers::AtomicEnterprise::ContainerManager::EventCatcher                   NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::EventCatcher
    NOVAHawk::Providers::AtomicEnterprise::ContainerManager::EventCatcher::Runner           NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::EventCatcher::Runner
    NOVAHawk::Providers::AtomicEnterprise::ContainerManager::EventParser                    NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::EventParser
    NOVAHawk::Providers::AtomicEnterprise::ContainerManager::MetricsCollectorWorker         NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::MetricsCollectorWorker
    NOVAHawk::Providers::AtomicEnterprise::ContainerManager::MetricsCollectorWorker::Runner NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::MetricsCollectorWorker::Runner
    NOVAHawk::Providers::AtomicEnterprise::ContainerManager::RefreshParser                  NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::RefreshParser
    NOVAHawk::Providers::AtomicEnterprise::ContainerManager::RefreshWorker                  NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::RefreshWorker
    NOVAHawk::Providers::AtomicEnterprise::ContainerManager::RefreshWorker::Runner          NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::RefreshWorker::Runner
    NOVAHawk::Providers::AtomicEnterprise::ContainerManager::Refresher                      NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::Refresher
  )]

  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class MiqWorker < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Authentication < ActiveRecord::Base; end
  class MiqQueue < ActiveRecord::Base; end

  def up
    say_with_time "Rename class references for Atomic and AtomicEnterprise" do
      rename_class_references(NAME_MAP)
    end

    say_with_time "Rename Atomic to Openshift in Authentication:name" do
      Authentication.update_all("name = replace(name, 'NOVAHawk::Providers::Atomic', 'NOVAHawk::Providers::Openshift')")
    end

    say_with_time "Rename Atomic to Openshift in MiqQueue:args" do
      MiqQueue.update_all("args = replace(args, 'NOVAHawk::Providers::Atomic', 'NOVAHawk::Providers::Openshift')")
    end
  end
end
