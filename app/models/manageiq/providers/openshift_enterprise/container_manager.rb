class NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager < NOVAHawk::Providers::ContainerManager
  include NOVAHawk::Providers::Openshift::ContainerManagerMixin

  require_nested :EventCatcher
  require_nested :EventParser
  require_nested :MetricsCollectorWorker
  require_nested :RefreshParser
  require_nested :RefreshWorker
  require_nested :Refresher

  def self.ems_type
    @ems_type ||= "openshift_enterprise".freeze
  end

  def self.description
    @description ||= "OpenShift Container Platform".freeze
  end

  def self.event_monitor_class
    NOVAHawk::Providers::OpenshiftEnterprise::ContainerManager::EventCatcher
  end
end
