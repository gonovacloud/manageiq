module MiqAeMethodService
  class MiqAeServiceNOVAHawk_Providers_OpenshiftEnterprise_ContainerManager < MiqAeServiceNOVAHawk_Providers_ContainerManager
    expose :container_image_registries, :association => true
    expose :container_projects,         :association => true
  end
end
