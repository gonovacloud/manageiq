module MiqAeMethodService
  class MiqAeServiceNOVAHawk_Providers_Azure_CloudManager_Provision < MiqAeServiceNOVAHawk_Providers_CloudManager_Provision
    expose_eligible_resources :resource_groups
  end
end
