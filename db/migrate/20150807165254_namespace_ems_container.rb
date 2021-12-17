class NamespaceEmsContainer < ActiveRecord::Migration
  include MigrationHelper

  NAME_MAP = Hash[*%w(
    EmsKubernetes                     NOVAHawk::Providers::Kubernetes::ContainerManager
    ContainerKubernetes               NOVAHawk::Providers::Kubernetes::ContainerManager::Container
    ContainerGroupKubernetes          NOVAHawk::Providers::Kubernetes::ContainerManager::ContainerGroup
    ContainerNodeKubernetes           NOVAHawk::Providers::Kubernetes::ContainerManager::ContainerNode
    MiqEventCatcherKubernetes         NOVAHawk::Providers::Kubernetes::ContainerManager::EventCatcher
    EventCatcherKubernetes            NOVAHawk::Providers::Kubernetes::ContainerManager::EventCatcher::Runner
    MiqEmsRefreshWorkerKubernetes     NOVAHawk::Providers::Kubernetes::ContainerManager::RefreshWorker
    EmsRefreshWorkerKubernetes        NOVAHawk::Providers::Kubernetes::ContainerManager::RefreshWorker::Runner

    EmsOpenshift                      NOVAHawk::Providers::Openshift::ContainerManager
    MiqEventCatcherOpenshift          NOVAHawk::Providers::Openshift::ContainerManager::EventCatcher
    EventCatcherOpenshift             NOVAHawk::Providers::Openshift::ContainerManager::EventCatcher::Runner
    MiqEmsRefreshWorkerOpenshift      NOVAHawk::Providers::Openshift::ContainerManager::RefreshWorker
    EmsRefreshWorkerOpenshift         NOVAHawk::Providers::Openshift::ContainerManager::RefreshWorker::Runner
  )]

  def change
    say_with_time "Rename class references for Kubernetes and Openshift" do
      rename_class_references(NAME_MAP)
    end
  end
end
