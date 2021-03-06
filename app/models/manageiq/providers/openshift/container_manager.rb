class NOVAHawk::Providers::Openshift::ContainerManager < NOVAHawk::Providers::ContainerManager
  include NOVAHawk::Providers::Openshift::ContainerManagerMixin

  require_nested :EventCatcher
  require_nested :EventParser
  require_nested :MetricsCollectorWorker
  require_nested :RefreshParser
  require_nested :RefreshWorker
  require_nested :Refresher

  def self.ems_type
    @ems_type ||= "openshift".freeze
  end

  def self.description
    @description ||= "OpenShift Origin".freeze
  end

  def self.event_monitor_class
    NOVAHawk::Providers::Openshift::ContainerManager::EventCatcher
  end

  def supported_auth_attributes
    %w(userid password auth_key)
  end
end
