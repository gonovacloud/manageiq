class NOVAHawk::Providers::Openstack::CloudManager::RefreshWorker < ::MiqEmsRefreshWorker
  require_nested :Runner

  def self.ems_class
    NOVAHawk::Providers::Openstack::CloudManager
  end
end
