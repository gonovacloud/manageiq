class NOVAHawk::Providers::Vmware::NetworkManager::RefreshWorker < ::MiqEmsRefreshWorker
  require_nested :Runner

  def self.ems_class
    NOVAHawk::Providers::Vmware::NetworkManager
  end

  def self.settings_name
    :ems_refresh_worker_vmware_cloud
  end
end
