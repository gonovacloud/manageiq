require Rails.root.join('db/fixtures/ae_datastore/NOVAHawk/ConfigurationManagement/AnsibleTower/Service/Provisioning/StateMachines/Provision.class/__methods__/provision').to_s

describe AnsibleTowerProvision do
  let(:admin) { FactoryGirl.create(:user_admin) }
  let(:request) { FactoryGirl.create(:service_template_provision_request, :requester => admin) }
  let(:job_class) { NOVAHawk::Providers::AnsibleTower::ConfigurationManager::Job }
  let(:ansible_tower_manager) { FactoryGirl.create(:configuration_manager) }
  let(:job_template) { FactoryGirl.create(:ansible_configuration_script, :manager => ansible_tower_manager) }
  let(:service_ansible_tower) { FactoryGirl.create(:service_ansible_tower, :job_template => job_template) }
  let(:job) { FactoryGirl.create(:ansible_tower_job) }
  let(:task) { FactoryGirl.create(:service_template_provision_task, :destination => service_ansible_tower, :miq_request => request) }
  let(:svc_task) { MiqAeMethodService::MiqAeServiceServiceTemplateProvisionTask.find(task.id) }
  let(:root_object) { Spec::Support::MiqAeMockObject.new('service_template_provision_task' => svc_task) }
  let(:ae_service) { Spec::Support::MiqAeMockService.new(root_object) }

  it "launches an Ansible Tower job" do
    expect(job_class).to receive(:create_job).and_return(job)
    described_class.new(ae_service).main
  end

  it "fails the step when job launching fails" do
    expect(job_class).to receive(:create_job).and_raise('provider error')
    described_class.new(ae_service).main
    expect(ae_service.root['ae_result']).to eq('error')
    expect(ae_service.root['ae_reason']).to eq('provider error')
  end
end
