class NOVAHawk::Providers::Vmware::InfraManager::MetricsCollectorWorker::Runner < NOVAHawk::Providers::BaseManager::MetricsCollectorWorker::Runner
  self.require_vim_broker = true
end
