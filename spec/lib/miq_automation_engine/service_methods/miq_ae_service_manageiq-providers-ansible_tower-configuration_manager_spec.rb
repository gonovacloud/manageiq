module MiqAeServiceNOVAHawkProvidersAnsibleTowerConfigurationManagerSpec
  include MiqAeEngine
  describe MiqAeMethodService::MiqAeServiceNOVAHawk_Providers_AnsibleTower_ConfigurationManager do
    let(:provider)              { FactoryGirl.create(:provider_ansible_tower) }
    let(:configuration_manager) { FactoryGirl.create(:configuration_manager_ansible_tower, :provider => provider) }

    it "get the service model" do
      configuration_manager
      svc = described_class.find(configuration_manager.id)

      expect(svc.name).to eq(configuration_manager.name)
    end
  end
end
