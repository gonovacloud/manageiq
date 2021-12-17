class NOVAHawk::Providers::Vmware::InfraManager::ProvisionViaPxe < NOVAHawk::Providers::Vmware::InfraManager::Provision
  include_concern 'Cloning'
  include_concern 'Pxe'
  include_concern 'StateMachine'
end
