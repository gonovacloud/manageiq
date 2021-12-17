class NOVAHawk::Providers::Openstack::NetworkManager::RefreshWorker < ::MiqEmsRefreshWorker
  require_nested :Runner

  def self.ems_class
    NOVAHawk::Providers::Openstack::NetworkManager
  end

  def self.settings_name
    :ems_refresh_worker_openstack_network
  end
end
