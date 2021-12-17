class NamespaceEmsAzure < ActiveRecord::Migration
  include MigrationHelper

  NAME_MAP = Hash[*%w(
    EmsAzure                                             NOVAHawk::Providers::Azure::CloudManager
    AvailabilityZoneAzure                                NOVAHawk::Providers::Azure::CloudManager::AvailabilityZone
    FlavorAzure                                          NOVAHawk::Providers::Azure::CloudManager::Flavor
    EmsRefresh::Parsers::Azure                           NOVAHawk::Providers::Azure::CloudManager::RefreshParser
    MiqEmsRefreshWorkerAzure                             NOVAHawk::Providers::Azure::CloudManager::RefreshWorker
    EmsRefresh::Refreshers::AzureRefresher               NOVAHawk::Providers::Azure::CloudManager::Refresher
    VmAzure                                              NOVAHawk::Providers::Azure::CloudManager::Vm
  )]

  def change
    say_with_time "Renaming class references for Azure namespace" do
      rename_class_references(NAME_MAP)
    end
  end
end
