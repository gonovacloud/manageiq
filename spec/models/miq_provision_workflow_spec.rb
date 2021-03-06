silence_warnings { MiqProvisionWorkflow.const_set("DIALOGS_VIA_AUTOMATE", false) }

describe MiqProvisionWorkflow do
  let(:admin) { FactoryGirl.create(:user_admin) }
  let(:server) { EvmSpecHelper.local_miq_server }
  let(:dialog) { FactoryGirl.create(:miq_dialog_provision) }
  context "seeded" do
    context "After setup," do
      before do
        server
        dialog
      end
      context "Without a Valid Template," do
        it "should not create an MiqRequest when calling from_ws" do
          expect do
            NOVAHawk::Providers::Vmware::InfraManager::ProvisionWorkflow.from_ws(
              "1.0", admin, "template", "target", false, "cc|001|environment|test", "")
          end.to raise_error(RuntimeError)
        end
      end

      context "With a Valid Template," do
        before(:each) do
          @ems         = FactoryGirl.create(:ems_vmware, :name => "Test EMS", :zone => server.zone)
          @host        = FactoryGirl.create(:host, :name => "test_host", :hostname => "test_host", :state => 'on',
                                            :ext_management_system => @ems)
          @vm_template = FactoryGirl.create(:template_vmware, :name => "template", :ext_management_system => @ems,
                                            :host => @host)
          @hardware    = FactoryGirl.create(:hardware, :vm_or_template => @vm_template, :guest_os => "winxppro",
                                            :memory_mb => 512,
                                            :cpu_sockets => 2)
          @switch      = FactoryGirl.create(:switch, :name => 'vSwitch0', :ports => 32, :hosts => [@host])
          @lan         = FactoryGirl.create(:lan, :name => "VM Network", :switch => @switch)
          @ethernet    = FactoryGirl.create(:guest_device, :hardware => @hardware, :lan => @lan,
                                            :device_type => 'ethernet',
                                            :controller_type => 'ethernet', :address => '00:50:56:ba:10:6b',
                                            :present => false, :start_connected => true)
        end

        it "should create an MiqRequest when calling from_ws" do
          FactoryGirl.create(:classification_cost_center_with_tags)
          request = NOVAHawk::Providers::Vmware::InfraManager::ProvisionWorkflow.from_ws(
            "1.0", admin, "template", "target", false, "cc|001|environment|test", "")
          expect(request).to be_a_kind_of(MiqRequest)

          expect(request.options[:vm_tags]).to eq([Classification.find_by_name("cc/001").id])
        end

        it "should set tags" do
          FactoryGirl.create(:classification_cost_center_with_tags)
          request = NOVAHawk::Providers::Vmware::InfraManager::ProvisionWorkflow.from_ws(
            "1.1", admin, {'name' => 'template'}, {'vm_name' => 'spec_test'}, nil,
            {'cc' => '001', 'environment' => 'test'}, nil, nil, nil)
          expect(request).to be_a_kind_of(MiqRequest)

          expect(request.options[:vm_tags]).to eq([Classification.find_by_name("cc/001").id])
        end

        it "should encrypt fields" do
          password_input = "secret"
          request = NOVAHawk::Providers::Vmware::InfraManager::ProvisionWorkflow.from_ws(
            "1.1", admin, {'name' => 'template'}, {'vm_name' => 'spec_test', 'root_password' => password_input.dup}, # dup because it's mutated
            {'owner_email' => 'admin'}, {'owner_first_name' => 'test'},
            {'owner_last_name' => 'test'}, nil, nil, nil, nil)

          expect(MiqPassword.encrypted?(request.options[:root_password])).to be_truthy
          expect(MiqPassword.decrypt(request.options[:root_password])).to eq(password_input)
        end

        it "should set values when extra '|' are passed in for multiple values" do
          request = NOVAHawk::Providers::Vmware::InfraManager::ProvisionWorkflow.from_ws(
            "1.1", admin, {'name' => 'template'}, {'vm_name' => 'spec_test'},
            nil, nil, {'abc' => 'tr|ue', 'blah' => 'na|h'}, nil, nil)

          expect(request.options[:ws_values]).to include(:blah => "na|h")
        end

        it "should set values when only a single key value pair is passed in as a string" do
          Vmdb::Deprecation.silenced do
            request = NOVAHawk::Providers::Vmware::InfraManager::ProvisionWorkflow.from_ws(
              "1.1", admin, {'name' => 'template'}, {'vm_name' => 'spec_test'},
              nil, nil, "abc=true", nil, nil)

            expect(request.options[:ws_values]).to include(:abc => "true")
          end
        end

        it "should set values when all args are passed in as a string" do
          Vmdb::Deprecation.silenced do
            request = NOVAHawk::Providers::Vmware::InfraManager::ProvisionWorkflow.from_ws(
              "1.1", admin, "name=template", "vm_name=spec_test",
              nil, nil, "abc=true", nil, nil)

            expect(request.options[:ws_values]).to include(:abc => "true")
          end
        end
      end
    end
  end

  context ".encrypted_options_fields" do
    MiqProvisionWorkflow.descendants.each do |sub_klass|
      it("with class #{sub_klass}") { expect(sub_klass.encrypted_options_fields).to include(:root_password) }
    end
  end

  context '.class_for_source' do
    let(:provider)       { FactoryGirl.create(:ems_amazon) }
    let(:template)       { FactoryGirl.create(:template_amazon, :name => "template") }
    let(:workflow_class) { provider.class.provision_workflow_class }

    it 'with valid source' do
      template.update_attributes(:ext_management_system => provider)
      expect(described_class.class_for_source(template.id)).to eq(workflow_class)
    end

    it 'with orphaned source' do
      template.storage = FactoryGirl.create(:storage)

      expect(template.orphaned?).to be_truthy
      expect(described_class.class_for_source(template.id)).to eq(workflow_class)
    end

    it 'with archived source' do
      expect(template.archived?).to be_truthy
      expect(described_class.class_for_source(template.id)).to eq(workflow_class)
    end
  end

  context '.class_for_platform' do
    {
      "openstack" => NOVAHawk::Providers::Openstack::CloudManager::ProvisionWorkflow,
      "redhat"    => NOVAHawk::Providers::Redhat::InfraManager::ProvisionWorkflow,
      "vmware"    => NOVAHawk::Providers::Vmware::InfraManager::ProvisionWorkflow,
    }.each do |k, v|
      it(k) { expect(described_class.class_for_platform(k)).to eq(v) }
    end
  end
end
