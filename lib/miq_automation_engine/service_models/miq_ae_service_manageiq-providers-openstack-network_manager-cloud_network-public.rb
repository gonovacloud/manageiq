module MiqAeMethodService
  class MiqAeServiceNOVAHawk_Providers_Openstack_NetworkManager_CloudNetwork_Public < MiqAeServiceNOVAHawk_Providers_Openstack_NetworkManager_CloudNetwork
    expose :private_networks, :association => true
  end
end
