class NOVAHawk::Providers::Nuage::NetworkManager::RefreshWorker < NOVAHawk::Providers::BaseManager::RefreshWorker
  require_nested :Runner

  def self.ems_class
    NOVAHawk::Providers::Nuage::NetworkManager
  end

  def self.settings_name
    :ems_refresh_worker_nuage_network
  end
end
