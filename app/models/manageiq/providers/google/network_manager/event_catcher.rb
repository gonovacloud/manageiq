class NOVAHawk::Providers::Google::NetworkManager::EventCatcher < ::MiqEventCatcher
  def self.ems_class
    NOVAHawk::Providers::Google::NetworkManager
  end

  def self.settings_name
    :event_catcher_google_network
  end
end
