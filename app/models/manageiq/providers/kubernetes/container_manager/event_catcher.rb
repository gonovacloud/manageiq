class NOVAHawk::Providers::Kubernetes::ContainerManager::EventCatcher < NOVAHawk::Providers::BaseManager::EventCatcher
  require_nested :Runner
  def self.ems_class
    NOVAHawk::Providers::Kubernetes::ContainerManager
  end
end
