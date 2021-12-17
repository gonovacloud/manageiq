class NOVAHawk::Providers::Azure::CloudManager::MetricsCollectorWorker < NOVAHawk::Providers::BaseManager::MetricsCollectorWorker
  require_nested :Runner

  self.default_queue_name = "azure"

  def friendly_name
    @friendly_name ||= "C&U Metrics Collector for Azure"
  end
end
