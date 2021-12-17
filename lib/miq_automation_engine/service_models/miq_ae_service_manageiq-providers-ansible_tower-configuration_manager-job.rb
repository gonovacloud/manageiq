module MiqAeMethodService
  class MiqAeServiceNOVAHawk_Providers_AnsibleTower_ConfigurationManager_Job < MiqAeServiceOrchestrationStack
    expose :job_template, :association => true
    expose :refresh_ems
    expose :raw_stdout

    def self.create_job(template, args = {})
      template_object = ConfigurationScript.find_by(:id => template.id)
      klass = NOVAHawk::Providers::AnsibleTower::ConfigurationManager::Job
      wrap_results(klass.create_job(template_object, args))
    end
  end
end
