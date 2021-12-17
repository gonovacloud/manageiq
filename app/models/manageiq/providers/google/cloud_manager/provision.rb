class NOVAHawk::Providers::Google::CloudManager::Provision < ::MiqProvisionCloud
  include_concern 'Cloning'
  include_concern 'Disk'
  include_concern 'StateMachine'
end
