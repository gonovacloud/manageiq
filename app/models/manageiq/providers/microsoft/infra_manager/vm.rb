class NOVAHawk::Providers::Microsoft::InfraManager::Vm < NOVAHawk::Providers::InfraManager::Vm
  include_concern 'NOVAHawk::Providers::Microsoft::InfraManager::VmOrTemplateShared'

  supports_not :migrate, :reason => _("Migrate operation is not supported.")

  POWER_STATES = {
    "Running"  => "on",
    "Paused"   => "suspended",
    "Saved"    => "suspended",
    "PowerOff" => "off",
  }.freeze

  def self.calculate_power_state(raw_power_state)
    POWER_STATES[raw_power_state] || super
  end

  def proxies4job(_job = nil)
    {
      :proxies => [MiqServer.my_server],
      :message => 'Perform SmartState Analysis on this VM'
    }
  end

  def has_active_proxy?
    true
  end

  def has_proxy?
    true
  end

  def validate_publish
    validate_unsupported("Publish VM")
  end

  def validate_reset
    validate_vm_control_powered_on
  end
end
