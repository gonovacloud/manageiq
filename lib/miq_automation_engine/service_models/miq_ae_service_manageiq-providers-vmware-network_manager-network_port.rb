module MiqAeMethodService
  class MiqAeServiceNOVAHawk_Providers_Vmware_NetworkManager_NetworkPort < MiqAeServiceNetworkPort
    expose :cloud_subnets, :association => true
  end
end
