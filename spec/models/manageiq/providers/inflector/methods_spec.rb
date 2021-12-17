describe NOVAHawk::Providers::Inflector::Methods do
  context "#provider_name" do
    it "returns name for an instance" do
      manager = NOVAHawk::Providers::Amazon::CloudManager.new
      expect(manager.provider_name).to eq('Amazon')
    end

    it "returns name for a class" do
      manager = NOVAHawk::Providers::Amazon::CloudManager
      expect(manager.provider_name).to eq('Amazon')
    end

    it "returns name for a vm" do
      vm = NOVAHawk::Providers::Amazon::CloudManager::Vm.new
      expect(vm.provider_name).to eq('Amazon')
    end
  end
end
