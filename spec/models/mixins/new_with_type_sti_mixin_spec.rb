describe NewWithTypeStiMixin do
  context ".new" do
    it "without type" do
      expect(Host.new.class).to eq(Host)
      expect(NOVAHawk::Providers::Redhat::InfraManager::Host.new.class).to eq(NOVAHawk::Providers::Redhat::InfraManager::Host)
      expect(NOVAHawk::Providers::Vmware::InfraManager::Host.new.class).to eq(NOVAHawk::Providers::Vmware::InfraManager::Host)
      expect(NOVAHawk::Providers::Vmware::InfraManager::HostEsx.new.class).to eq(NOVAHawk::Providers::Vmware::InfraManager::HostEsx)
    end

    it "with type" do
      expect(Host.new(:type => "Host").class).to eq(Host)
      expect(Host.new(:type => "NOVAHawk::Providers::Redhat::InfraManager::Host").class).to eq(NOVAHawk::Providers::Redhat::InfraManager::Host)
      expect(Host.new(:type => "NOVAHawk::Providers::Vmware::InfraManager::Host").class).to eq(NOVAHawk::Providers::Vmware::InfraManager::Host)
      expect(Host.new(:type => "NOVAHawk::Providers::Vmware::InfraManager::HostEsx").class).to eq(NOVAHawk::Providers::Vmware::InfraManager::HostEsx)
      expect(NOVAHawk::Providers::Vmware::InfraManager::Host.new(:type  => "NOVAHawk::Providers::Vmware::InfraManager::HostEsx").class).to eq(NOVAHawk::Providers::Vmware::InfraManager::HostEsx)

      expect(Host.new("type" => "Host").class).to eq(Host)
      expect(Host.new("type" => "NOVAHawk::Providers::Redhat::InfraManager::Host").class).to eq(NOVAHawk::Providers::Redhat::InfraManager::Host)
      expect(Host.new("type" => "NOVAHawk::Providers::Vmware::InfraManager::Host").class).to eq(NOVAHawk::Providers::Vmware::InfraManager::Host)
      expect(Host.new("type" => "NOVAHawk::Providers::Vmware::InfraManager::HostEsx").class).to eq(NOVAHawk::Providers::Vmware::InfraManager::HostEsx)
      expect(NOVAHawk::Providers::Vmware::InfraManager::Host.new("type" => "NOVAHawk::Providers::Vmware::InfraManager::HostEsx").class).to eq(NOVAHawk::Providers::Vmware::InfraManager::HostEsx)
    end

    context "with invalid type" do
      it "that doesn't exist" do
        expect { Host.new(:type  => "Xxx") }.to raise_error(NameError)
        expect { Host.new("type" => "Xxx") }.to raise_error(NameError)
      end

      it "that isn't a subclass" do
        expect { Host.new(:type  => "NOVAHawk::Providers::Vmware::InfraManager::Vm") }
          .to raise_error(RuntimeError, /Vm is not a subclass of Host/)
        expect { Host.new("type" => "NOVAHawk::Providers::Vmware::InfraManager::Vm") }
          .to raise_error(RuntimeError, /Vm is not a subclass of Host/)

        expect { NOVAHawk::Providers::Vmware::InfraManager::Host.new(:type  => "Host") }
          .to raise_error(RuntimeError, /Host is not a subclass of NOVAHawk::Providers::.*/)
        expect { NOVAHawk::Providers::Vmware::InfraManager::Host.new("type" => "Host") }
          .to raise_error(RuntimeError, /Host is not a subclass of NOVAHawk::Providers::.*/)

        expect do
          NOVAHawk::Providers::Vmware::InfraManager::Host
            .new(:type => "NOVAHawk::Providers::Redhat::InfraManager::Host")
        end.to raise_error(RuntimeError, /NOVAHawk.*Redhat.*is not a subclass of NOVAHawk.*Vmware.*/)

        expect do
          NOVAHawk::Providers::Vmware::InfraManager::Host
            .new("type" => "NOVAHawk::Providers::Redhat::InfraManager::Host")
        end.to raise_error(RuntimeError, /NOVAHawk.*Redhat.*is not a subclass of NOVAHawk.*Vmware.*/)
      end
    end
  end
end
