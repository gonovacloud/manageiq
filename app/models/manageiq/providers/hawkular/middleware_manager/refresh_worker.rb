class NOVAHawk::Providers::Hawkular::MiddlewareManager::RefreshWorker < NOVAHawk::Providers::BaseManager::RefreshWorker
  require_nested :Runner

  def self.ems_class
    NOVAHawk::Providers::Hawkular::MiddlewareManager
  end
end
