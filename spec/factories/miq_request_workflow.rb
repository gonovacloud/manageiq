FactoryGirl.define do
  factory :miq_request_workflow do
    skip_create
  end

  factory :miq_provision_workflow, :class => "MiqProvisionWorkflow", :parent => :miq_request_workflow do
    initialize_with do
      new({:provision_dialog_name => create(:miq_dialog_provision).name}, create(:user_with_group).userid)
    end
  end

  factory :miq_provision_configured_system_foreman_workflow, :parent => :miq_request_workflow, :class => "NOVAHawk::Providers::Foreman::ConfigurationManager::ProvisionWorkflow" do
    initialize_with do
      new({:provision_dialog_name => create(:miq_provision_configured_system_foreman_dialog).name}, create(:user_with_group).userid)
    end
  end

  factory :miq_provision_virt_workflow, :class => "MiqProvisionVirtWorkflow", :parent => :miq_provision_workflow
end
