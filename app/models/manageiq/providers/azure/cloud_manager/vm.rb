class NOVAHawk::Providers::Azure::CloudManager::Vm < NOVAHawk::Providers::CloudManager::Vm
  include_concern 'Operations'
  include_concern 'NOVAHawk::Providers::Azure::CloudManager::VmOrTemplateShared'

  def provider_service(connection = nil)
    connection ||= ext_management_system.connect
    ::Azure::Armrest::VirtualMachineService.new(connection)
  end

  # The resource group is stored as part of the uid_ems. This splits it out.
  def resource_group
    uid_ems.split('\\')[1]
  end

  #
  # Relationship methods
  #

  def disconnect_inv
    super

    # Mark all instances no longer found as unknown
    self.raw_power_state = "unknown"
    save
  end

  def disconnected
    false
  end

  def disconnected?
    false
  end

  def memory_mb_available?
    true
  end

  def self.calculate_power_state(raw_power_state)
    case raw_power_state.downcase
    when /running/, /starting/
      "on"
    when /stopped/, /stopping/
      "suspended"
    when /dealloc/
      "off"
    else
      "unknown"
    end
  end
end
