class NOVAHawk::Providers::Google::NetworkManager::RefreshWorker < ::MiqEmsRefreshWorker
  require_nested :Runner

  def self.ems_class
    NOVAHawk::Providers::Google::NetworkManager
  end

  def self.settings_name
    :ems_refresh_worker_google_network
  end
end
