class NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::EventCatcher < NOVAHawk::Providers::BaseManager::EventCatcher
  require_nested :Runner
  def self.ems_class
    NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager
  end
end
