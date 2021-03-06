describe MiqProvisionRequest do
  it ".request_task_class_from" do
    ems = FactoryGirl.create(:ems_vmware)
    vm = FactoryGirl.create(:vm_vmware, :ext_management_system => ems)
    expect(described_class.request_task_class_from('options' => {:src_vm_id => vm.id})).to eq NOVAHawk::Providers::Vmware::InfraManager::Provision
    expect(described_class.request_task_class_from('options' => {:src_vm_id => vm.id, :provision_type => "pxe"})).to eq NOVAHawk::Providers::Vmware::InfraManager::ProvisionViaPxe

    ems = FactoryGirl.create(:ems_redhat)
    vm = FactoryGirl.create(:vm_redhat, :ext_management_system => ems)
    expect(described_class.request_task_class_from('options' => {:src_vm_id => vm.id})).to eq NOVAHawk::Providers::Redhat::InfraManager::Provision

    ems = FactoryGirl.create(:ems_openstack)
    vm = FactoryGirl.create(:vm_openstack, :ext_management_system => ems)
    expect(described_class.request_task_class_from('options' => {:src_vm_id => vm.id})).to eq NOVAHawk::Providers::Openstack::CloudManager::Provision

    ems = FactoryGirl.create(:ems_amazon)
    vm = FactoryGirl.create(:vm_amazon, :ext_management_system => ems)
    expect(described_class.request_task_class_from('options' => {:src_vm_id => vm.id})).to eq NOVAHawk::Providers::Amazon::CloudManager::Provision
  end

  context "A new provision request," do
    before            { allow_any_instance_of(User).to receive(:role).and_return("admin") }
    let(:approver)    { FactoryGirl.create(:user_miq_request_approver) }
    let(:user)        { FactoryGirl.create(:user) }
    let(:ems)         { FactoryGirl.create(:ems_vmware) }
    let(:vm)          { FactoryGirl.create(:vm_vmware, :name => "vm1", :location => "abc/def.vmx") }
    let(:vm_template) { FactoryGirl.create(:template_vmware, :name => "template1", :ext_management_system => ems) }

    it "should not be created without requester being specified" do
      expect { FactoryGirl.create(:miq_provision_request) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not be created with an invalid userid being specified" do
      expect { FactoryGirl.create(:miq_provision_request, :userid => 'barney', :src_vm_id => vm_template.id) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not be created with a valid userid but no vm being specified" do
      expect { FactoryGirl.create(:miq_provision_request, :requester => user, :source => nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should be created from either a VM or Template" do
      expect { FactoryGirl.create(:miq_provision_request, :requester => user, :src_vm_id => vm_template.id) }.not_to raise_error
      expect { FactoryGirl.create(:miq_provision_request, :requester => user, :src_vm_id => vm.id) }.not_to raise_error
    end

    it "should not be created with a valid userid but invalid vm being specified" do
      expect { FactoryGirl.create(:miq_provision_request, :requester => user, :src_vm_id => 42) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    context "with a valid userid and source vm," do
      before do
        @pr = FactoryGirl.create(:miq_provision_request, :requester => user, :src_vm_id => vm_template.id, :options => {:owner_email => 'tester@miq.com'})
        @request = @pr.miq_request
      end

      it "should create an MiqProvisionRequest" do
        expect(MiqProvisionRequest.count).to eq(1)
        expect(MiqProvisionRequest.first).to eq(@pr)
        expect(@pr.valid?).to be_truthy
        expect(@pr.approved?).to be_falsey
      end

      it "should create a valid MiqRequest" do
        expect(@pr.miq_request).to eq(MiqRequest.first)
        expect(@pr.miq_request.valid?).to be_truthy
        expect(@pr.miq_request.approval_state).to eq("pending_approval")
        expect(@pr.miq_request.resource).to eq(@pr)
        expect(@pr.miq_request.requester_userid).to eq(user.userid)
        expect(@pr.miq_request.stamped_on).to be_nil

        expect(@pr.miq_request.approved?).to be_falsey
        expect(MiqApproval.count).to eq(1)
        expect(@pr.miq_request.first_approval).to eq(MiqApproval.first)
      end

      it "should return a workflow class" do
        expect(@pr.workflow_class).to eq(NOVAHawk::Providers::Vmware::InfraManager::ProvisionWorkflow)
      end

      context "when calling call_automate_event_queue" do
        before do
          @event_name = "request_created"
          @pr.miq_request.call_automate_event_queue(@event_name)
        end

        it "should create proper MiqQueue item" do
          expect(MiqQueue.count).to eq(1)
          q = MiqQueue.first
          expect(q.class_name).to eq(@pr.miq_request.class.name)
          expect(q.instance_id).to eq(@pr.miq_request.id)
          expect(q.method_name).to eq("call_automate_event")
          expect(q.args).to eq([@event_name])
          expect(q.zone).to eq(ems.zone.name)
        end
      end

      context "after MiqRequest is deleted," do
        before { @request.destroy }

        it "should delete MiqProvisionRequest" do
          expect(MiqProvisionRequest.count).to eq(0)
        end

        it "should delete MiqApproval" do
          expect(MiqApproval.count).to eq(0)
        end

        it "should not delete Approver" do
          expect { approver.reload }.not_to raise_error
        end
      end

      context "when calling quota methods" do
        before { EvmSpecHelper.create_guid_miq_server_zone }

        it "should return a hash for quota methods" do
          [:vms_by_group, :vms_by_owner, :retired_vms_by_group, :retired_vms_by_owner, :provisions_by_group, :provisions_by_owner,
           :requests_by_group, :requests_by_owner, :active_provisions_by_group, :active_provisions_by_owner, :active_provisions].each do |quota_method|
            expect(@pr.check_quota(quota_method)).to be_kind_of(Hash)
          end
        end

        it "should return stats from quota methods" do
          prov_options = {:number_of_vms => [2, '2'], :owner_email => 'tester@miq.com', :vm_memory => [1024, '1024'], :number_of_cpus => [2, '2']}
          @pr2 = FactoryGirl.create(:miq_provision_request, :requester => user, :src_vm_id => vm_template.id, :options => prov_options)

          stats = @pr.check_quota(:requests_by_owner)
          expect(stats).to be_kind_of(Hash)

          expect(stats[:class_name]).to eq("MiqProvisionRequest")
          expect(stats[:count]).to eq(2)
          expect(stats[:memory]).to eq(2.gigabytes)
          expect(stats[:cpu]).to eq(4)
          expect(stats.fetch_path(:active, :class_name)).to eq("MiqProvision")
        end
      end

      context "for cloud and infra providers," do
        def create_task(user, request)
          FactoryGirl.create(:miq_request_task, :miq_request => request, :miq_request_id => request.id, :type => 'MiqProvision', :description => "task", :tenant => user.current_tenant)
        end

        def create_request(user, vm_template, prov_options)
          FactoryGirl.create(:miq_provision_request, :requester   => user,
                                                     :description => "request",
                                                     :tenant      => user.current_tenant,
                                                     :source      => vm_template,
                                                     :src_vm_id   => vm_template.id,
                                                     :options     => prov_options.merge(:owner_email => user.email, :requester_group => user.miq_groups.first.description))
        end

        def request_queue_entry(request)
          FactoryGirl.create(:miq_queue,
                             :state       => MiqQueue::STATE_DEQUEUE,
                             :instance_id => request.id,
                             :class_name  => 'MiqProvisionRequest',
                             :method_name => 'create_request_tasks')
        end

        def task_queue_entry(task)
          FactoryGirl.create(:miq_queue,
                             :state       => MiqQueue::STATE_DEQUEUE,
                             :args        => [{:object_type => "Provision", :object_id => task.id}],
                             :task_id     => 'miq_provision_task',
                             :class_name  => 'MiqAeEngine',
                             :method_name => 'deliver')
        end

        def create_test_task(user, template)
          request = create_request(user, template, {})
          create_task(user, request)
          request
        end

        def queue(requests)
          requests.each do |request|
            request.miq_request_tasks.empty? ? request_queue_entry(request) : task_queue_entry(request.miq_request_tasks.first)
          end
        end

        let(:vmware_tasks) do
          ems = FactoryGirl.create(:ems_vmware)
          vmware_tenant = FactoryGirl.create(:tenant)
          group = FactoryGirl.create(:miq_group, :tenant => vmware_tenant)
          @vmware_user1 = FactoryGirl.create(:user_with_email, :miq_groups => [group])
          @vmware_user2 = FactoryGirl.create(:user_with_email, :miq_groups => [group])
          hardware = FactoryGirl.create(:hardware, :cpu1x2, :memory_mb => 512)
          @vmware_template = FactoryGirl.create(:template_vmware,
                                                :ext_management_system => ems,
                                                :hardware              => hardware)
          prov_options = {:number_of_vms => [2, '2'], :vm_memory => [1024, '1024'], :number_of_cpus => [2, '2']}
          requests = []
          2.times { requests << create_request(@vmware_user1, @vmware_template, prov_options) }
          create_task(@vmware_user1, requests.first)

          2.times { requests << create_request(@vmware_user2, @vmware_template, prov_options) }
          create_task(@vmware_user2, requests.last)
          requests
        end

        let(:google_tasks) do
          ems = FactoryGirl.create(:ems_google_with_authentication,
                                   :availability_zones => [FactoryGirl.create(:availability_zone_google)])
          google_tenant = FactoryGirl.create(:tenant)
          group = FactoryGirl.create(:miq_group, :tenant => google_tenant)
          @google_user1 = FactoryGirl.create(:user_with_email, :miq_groups => [group])
          @google_user2 = FactoryGirl.create(:user_with_email, :miq_groups => [group])
          @google_template = FactoryGirl.create(:template_google, :ext_management_system => ems)
          flavor = FactoryGirl.create(:flavor_google, :ems_id => ems.id,
                                      :cpus => 4, :cpu_cores => 1, :memory => 1024)
          prov_options = {:number_of_vms => 1, :src_vm_id => vm_template.id, :boot_disk_size => ["10.GB", "10 GB"],
                          :placement_auto => [true, 1], :instance_type => [flavor.id, flavor.name]}
          requests = []
          2.times { requests << create_request(@google_user1, @google_template, prov_options) }
          create_task(@google_user1, requests.first)

          2.times { requests << create_request(@google_user2, @google_template, prov_options) }
          create_task(@google_user2, requests.last)
          requests
        end

        shared_examples_for "check_quota" do
          it "check" do
            load_queue
            stats = request.check_quota(quota_method)
            expect(stats).to include(counts_hash)
          end
        end

        context "active_provisions," do
          let(:load_queue) { queue(vmware_tasks | google_tasks) }
          let(:request) { create_test_task(@vmware_user1, @vmware_template) }
          let(:quota_method) { :active_provisions }
          let(:counts_hash) do
            {:count => 12, :memory => 8_589_938_688, :cpu => 32, :storage => 44.gigabytes}
          end
          it_behaves_like "check_quota"
        end

        context "infra," do
          let(:load_queue) { queue(vmware_tasks | google_tasks) }
          let(:request) { create_test_task(@vmware_user1, @vmware_template) }
          let(:counts_hash) do
            {:count => 8, :memory => 8.gigabytes, :cpu => 16, :storage => 4.gigabytes}
          end

          context "active_provisions_by_tenant," do
            let(:quota_method) { :active_provisions_by_tenant }
            it_behaves_like "check_quota"
          end

          context "active_provisions_by_group," do
            let(:quota_method) { :active_provisions_by_group }
            it_behaves_like "check_quota"
          end

          context "active_provisions_by_owner," do
            let(:quota_method) { :active_provisions_by_owner }
            let(:counts_hash) do
              {:count => 4, :memory => 4.gigabytes, :cpu => 8, :storage => 2.gigabytes}
            end
            it_behaves_like "check_quota"
          end
        end

        context "cloud," do
          let(:load_queue) { queue(vmware_tasks | google_tasks) }
          let(:request) { create_test_task(@google_user1, @google_template) }
          let(:counts_hash) do
            {:count => 4, :memory => 4096, :cpu => 16, :storage => 40.gigabytes}
          end

          context "active_provisions_by_tenant," do
            let(:quota_method) { :active_provisions_by_tenant }
            it_behaves_like "check_quota"
          end

          context "active_provisions_by_group," do
            let(:quota_method) { :active_provisions_by_group }
            it_behaves_like "check_quota"
          end

          context "active_provisions_by_owner," do
            let(:quota_method) { :active_provisions_by_owner }
            let(:counts_hash) do
              {:count => 2, :memory => 2048, :cpu => 8, :storage => 20.gigabytes}
            end
            it_behaves_like "check_quota"
          end
        end
      end

      context "when processing tags" do
        before { FactoryGirl.create(:classification_department_with_tags) }

        it "should add and delete tags from a request" do
          expect(@pr.get_tags.length).to eq(0)

          t = Classification.where(:description => 'Department', :parent_id => 0).includes(:tag).first
          @pr.add_tag(t.name, t.children.first.name)
          expect(@pr.get_tags[t.name.to_sym]).to be_kind_of(String) # Single tag returns as a String
          expect(@pr.get_tags[t.name.to_sym]).to eq(t.children.first.name)

          # Adding the same tag again should not increase the tag count
          @pr.add_tag(t.name, t.children.first.name)
          expect(@pr.get_tags[t.name.to_sym]).to be_kind_of(String) # Single tag returns as a String
          expect(@pr.get_tags[t.name.to_sym]).to eq(t.children.first.name)

          # Verify that #get_tag with classification returns the single child tag name
          expect(@pr.get_tags[t.name.to_sym]).to eq(@pr.get_tag(t.name))

          t.children.each { |c| @pr.add_tag(t.name, c.name) }
          expect(@pr.get_tags[t.name.to_sym]).to be_kind_of(Array)
          expect(@pr.get_tags[t.name.to_sym].length).to eq(t.children.length)

          child_names = t.children.collect(&:name)
          # Make sure each child name is yield from the tag method
          @pr.tags { |tag_name, _classification| child_names.delete(tag_name) }
          expect(child_names).to be_empty

          tags = @pr.get_classification(t.name)
          expect(tags).to be_kind_of(Array)
          classification = tags.first
          expect(classification).to be_kind_of(Hash)
          expect(classification.keys).to include(:name)
          expect(classification.keys).to include(:description)

          child_names = t.children.collect(&:name)

          @pr.clear_tag(t.name, child_names[0])
          expect(@pr.get_tags[t.name.to_sym]).to be_kind_of(Array) # Multiple tags return as an Array
          expect(@pr.get_tags[t.name.to_sym].length).to eq(t.children.length - 1)

          @pr.clear_tag(t.name, child_names[1])
          expect(@pr.get_tags[t.name.to_sym]).to be_kind_of(String) # Single tag returns as a String
          expect(@pr.get_tags[t.name.to_sym]).to eq(child_names[2])

          @pr.clear_tag(t.name)
          expect(@pr.get_tags[t.name.to_sym]).to be_nil # No tags returns as nil
          expect(@pr.get_tags.length).to eq(0)
        end

        it "should return classifications for tags" do
          expect(@pr.get_tags.length).to eq(0)

          t = Classification.where(:description => 'Department', :parent_id => 0).includes(:tag).first
          @pr.add_tag(t.name, t.children.first.name)
          expect(@pr.get_tags[t.name.to_sym]).to be_kind_of(String)

          classification = @pr.get_classification(t.name)
          expect(classification).to be_kind_of(Hash)
          expect(classification.keys).to include(:name)
          expect(classification.keys).to include(:description)

          @pr.add_tag(t.name, t.children[1].name)
          expect(@pr.get_tags[t.name.to_sym]).to be_kind_of(Array)

          classification = @pr.get_classification(t.name)
          expect(classification).to be_kind_of(Array)
          first = classification.first
          expect(first.keys).to include(:name)
          expect(first.keys).to include(:description)
        end
      end
    end
  end
end
