class NOVAHawk::Providers::Microsoft::InfraManager::RefreshWorker < ::MiqEmsRefreshWorker
  require_nested :Runner

  def self.ems_class
    NOVAHawk::Providers::Microsoft::InfraManager
  end
end
