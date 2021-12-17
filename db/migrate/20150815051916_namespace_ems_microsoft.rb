class NamespaceEmsMicrosoft < ActiveRecord::Migration
  include MigrationHelper

  NAME_MAP = Hash[*%w(
    EmsMicrosoft                     NOVAHawk::Providers::Microsoft::InfraManager
    HostMicrosoft                    NOVAHawk::Providers::Microsoft::InfraManager::Host
    MiqEmsRefreshWorkerMicrosoft     NOVAHawk::Providers::Microsoft::InfraManager::RefreshWorker
    EmsRefreshWorkerMicrosoft        NOVAHawk::Providers::Microsoft::InfraManager::RefreshWorker::Runner
    TemplateMicrosoft                NOVAHawk::Providers::Microsoft::InfraManager::Template
    VmMicrosoft                      NOVAHawk::Providers::Microsoft::InfraManager::Vm
  )]

  def change
    say_with_time "Rename class references for Microsoft SCVMM" do
      rename_class_references(NAME_MAP)
    end
  end
end
