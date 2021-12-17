class NOVAHawk::Providers::Kubernetes::ContainerManager::RefreshWorker < NOVAHawk::Providers::BaseManager::RefreshWorker
  require_nested :Runner
  def self.ems_class
    NOVAHawk::Providers::Kubernetes::ContainerManager
  end
end
