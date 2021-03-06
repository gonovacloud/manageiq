class MiddlewareMessaging < ApplicationRecord
  belongs_to :ext_management_system, :foreign_key => "ems_id"
  belongs_to :middleware_server, :foreign_key => "server_id"
  acts_as_miq_taggable
  serialize :properties

  include LiveMetricsMixin

  def metrics_capture
    @metrics_capture ||= NOVAHawk::Providers::Hawkular::MiddlewareManager::LiveMetricsCapture.new(self)
  end

  def live_metrics_name
    "#{self.class.name.demodulize.underscore}_#{messaging_type.parameterize(:separator => '_')}"
  end

  def chart_report_name
    "#{self.class.name.demodulize.underscore}_#{messaging_type.parameterize(:separator => '_')}"
  end

  def chart_layout_path
    "#{self.class.name.gsub(/::/, '_')}_#{messaging_type.parameterize(:separator => '_')}"
  end

  def self.supported_models
    @supported_models ||= %w(queue topic).collect { |model| name.demodulize.underscore + "_jms_#{model}" }
  end
end
