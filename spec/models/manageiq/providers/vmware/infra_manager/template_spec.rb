describe NOVAHawk::Providers::Vmware::InfraManager::Template do
  context "#cloneable?" do
    let(:template_vmware) { NOVAHawk::Providers::Vmware::InfraManager::Template.new }

    it "returns true" do
      expect(template_vmware.cloneable?).to eq(true)
    end
  end
end
