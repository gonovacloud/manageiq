class NOVAHawk::Providers::Google::CloudManager::MetricsCollectorWorker <
  NOVAHawk::Providers::BaseManager::MetricsCollectorWorker
  require_nested :Runner

  self.default_queue_name = "google"

  def friendly_name
    @friendly_name ||= "C&U Metrics Collector for Google"
  end
end
