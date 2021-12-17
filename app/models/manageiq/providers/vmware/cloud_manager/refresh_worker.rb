class NOVAHawk::Providers::Vmware::CloudManager::RefreshWorker < NOVAHawk::Providers::BaseManager::RefreshWorker
  require_nested :Runner

  def self.settings_name
    :ems_refresh_worker_vmware_cloud
  end
end
