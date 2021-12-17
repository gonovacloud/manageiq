class NOVAHawk::Providers::Openshift::ContainerManager::EventCatcher < NOVAHawk::Providers::BaseManager::EventCatcher
  require_nested :Runner
  def self.ems_class
    NOVAHawk::Providers::Openshift::ContainerManager
  end
end
