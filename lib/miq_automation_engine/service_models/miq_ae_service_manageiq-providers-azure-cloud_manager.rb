module MiqAeMethodService
  class MiqAeServiceNOVAHawk_Providers_Azure_CloudManager < MiqAeServiceNOVAHawk_Providers_CloudManager
    expose :resource_groups, :association => true
  end
end
