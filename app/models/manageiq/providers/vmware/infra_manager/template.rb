class NOVAHawk::Providers::Vmware::InfraManager::Template < NOVAHawk::Providers::InfraManager::Template
  include_concern 'NOVAHawk::Providers::Vmware::InfraManager::VmOrTemplateShared'

  supports :provisioning do
    if ext_management_system
      unsupported_reason_add(:provisioning, ext_management_system.unsupported_reason(:provisioning)) unless ext_management_system.supports_provisioning?
    else
      unsupported_reason_add(:provisioning, _('not connected to ems'))
    end
  end

  def cloneable?
    true
  end
end
