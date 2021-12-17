describe MiqTemplate do
  it ".corresponding_model" do
    expect(described_class.corresponding_model).to eq(Vm)
    expect(NOVAHawk::Providers::Vmware::InfraManager::Template.corresponding_model).to eq(NOVAHawk::Providers::Vmware::InfraManager::Vm)
    expect(NOVAHawk::Providers::Redhat::InfraManager::Template.corresponding_model).to eq(NOVAHawk::Providers::Redhat::InfraManager::Vm)
  end

  it ".corresponding_vm_model" do
    expect(described_class.corresponding_vm_model).to eq(Vm)
    expect(NOVAHawk::Providers::Vmware::InfraManager::Template.corresponding_vm_model).to eq(NOVAHawk::Providers::Vmware::InfraManager::Vm)
    expect(NOVAHawk::Providers::Redhat::InfraManager::Template.corresponding_vm_model).to eq(NOVAHawk::Providers::Redhat::InfraManager::Vm)
  end

  context "#template=" do
    before(:each) { @template = FactoryGirl.create(:template_vmware) }

    it "true" do
      @template.update_attribute(:template, true)
      expect(@template.type).to eq("NOVAHawk::Providers::Vmware::InfraManager::Template")
      expect(@template.template).to eq(true)
      expect(@template.state).to eq("never")
      expect { @template.reload }.not_to raise_error
      expect { NOVAHawk::Providers::Vmware::InfraManager::Vm.find(@template.id) }.to raise_error ActiveRecord::RecordNotFound
    end

    it "false" do
      @template.update_attribute(:template, false)
      expect(@template.type).to eq("NOVAHawk::Providers::Vmware::InfraManager::Vm")
      expect(@template.template).to eq(false)
      expect(@template.state).to eq("unknown")
      expect { @template.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { NOVAHawk::Providers::Vmware::InfraManager::Vm.find(@template.id) }.not_to raise_error
    end
  end

  it ".supports_kickstart_provisioning?" do
    expect(NOVAHawk::Providers::Amazon::CloudManager::Template.supports_kickstart_provisioning?).to be_falsey
    expect(NOVAHawk::Providers::Redhat::InfraManager::Template.supports_kickstart_provisioning?).to be_truthy
    expect(NOVAHawk::Providers::Vmware::InfraManager::Template.supports_kickstart_provisioning?).to be_falsey
  end

  it "#supports_kickstart_provisioning?" do
    expect(NOVAHawk::Providers::Amazon::CloudManager::Template.new.supports_kickstart_provisioning?).to be_falsey
    expect(NOVAHawk::Providers::Redhat::InfraManager::Template.new.supports_kickstart_provisioning?).to be_truthy
    expect(NOVAHawk::Providers::Vmware::InfraManager::Template.new.supports_kickstart_provisioning?).to be_falsey
  end

  it "#supports_provisioning?" do
    template = FactoryGirl.create(:template_openstack)
    FactoryGirl.create(:ems_openstack, :miq_templates => [template])
    expect(template.supports_provisioning?).to be_truthy

    template = FactoryGirl.create(:template_openstack)
    expect(template.supports_provisioning?).to be_falsey

    template = FactoryGirl.create(:template_microsoft)
    expect(template.supports_provisioning?).to be_falsey

    template = FactoryGirl.create(:template_microsoft)
    FactoryGirl.create(:ems_openstack, :miq_templates => [template])
    expect(template.supports_provisioning?).to be_truthy
  end
end
