class NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::RefreshWorker < NOVAHawk::Providers::BaseManager::RefreshWorker
  require_nested :Runner

  def self.ems_class
    NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager
  end
end
