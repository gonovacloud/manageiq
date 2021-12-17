class NOVAHawk::Providers::StorageManager::CinderManager::EventCatcher < ::MiqEventCatcher
  require_nested :Runner

  def self.ems_class
    NOVAHawk::Providers::StorageManager::CinderManager
  end

  def self.settings_name
    :event_catcher_cinder
  end
end
