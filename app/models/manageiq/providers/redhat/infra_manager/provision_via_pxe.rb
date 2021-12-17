class NOVAHawk::Providers::Redhat::InfraManager::ProvisionViaPxe < NOVAHawk::Providers::Redhat::InfraManager::Provision
  include_concern 'Cloning'
  include_concern 'Configuration'
  include_concern 'StateMachine'
end
