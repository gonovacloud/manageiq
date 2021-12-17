class NOVAHawk::Providers::Azure::CloudManager::Provision < NOVAHawk::Providers::CloudManager::Provision
  include_concern 'Cloning'
  include_concern 'Configuration'
  include_concern 'OptionsHelper'
  include_concern 'StateMachine'
end
