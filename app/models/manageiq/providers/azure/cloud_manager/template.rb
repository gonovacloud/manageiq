class NOVAHawk::Providers::Azure::CloudManager::Template < ::NOVAHawk::Providers::CloudManager::Template
  include_concern 'NOVAHawk::Providers::Azure::CloudManager::VmOrTemplateShared'

  supports :provisioning do
    if ext_management_system
      unsupported_reason_add(:provisioning, ext_management_system.unsupported_reason(:provisioning)) unless ext_management_system.supports_provisioning?
    else
      unsupported_reason_add(:provisioning, _('not connected to ems'))
    end
  end

  def provider_object(connection = nil)
    connection ||= self.ext_management_system.connect
    connection.images[self.ems_ref]
  end
end
