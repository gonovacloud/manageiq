module MiqAeMethodService
  class MiqAeServiceNOVAHawk_Providers_Openstack_Provider < MiqAeServiceProvider
    expose :infra_ems, :association => true
    expose :cloud_ems, :association => true
  end
end
