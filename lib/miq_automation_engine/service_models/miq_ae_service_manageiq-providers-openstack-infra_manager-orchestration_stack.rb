module MiqAeMethodService
  class MiqAeServiceNOVAHawk_Providers_Openstack_InfraManager_OrchestrationStack < MiqAeServiceOrchestrationStack
    expose :raw_update_stack
    expose :update_ready?
  end
end
