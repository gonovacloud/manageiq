class NOVAHawk::Providers::Openshift::ContainerManager::RefreshWorker < NOVAHawk::Providers::BaseManager::RefreshWorker
  require_nested :Runner
  def self.ems_class
    NOVAHawk::Providers::Openshift::ContainerManager
  end
end
