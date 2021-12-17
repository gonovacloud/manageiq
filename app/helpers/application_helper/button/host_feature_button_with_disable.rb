class ApplicationHelper::Button::HostFeatureButtonWithDisable < ApplicationHelper::Button::GenericFeatureButtonWithDisable

  def visible?
    unless @feature.nil? || @record.nil?
      return false if @record.kind_of?(NOVAHawk::Providers::Openstack::InfraManager)
      return @record.is_available?(@feature) if @record.kind_of?(NOVAHawk::Providers::Openstack::InfraManager::Host)
    end
    true
  end

  def disabled?
    false
  end
end
