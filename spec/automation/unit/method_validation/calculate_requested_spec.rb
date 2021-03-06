describe "Quota Validation" do
  include Spec::Support::QuotaHelper
  include Spec::Support::ServiceTemplateHelper

  def run_automate_method(attrs)
    MiqAeEngine.instantiate("/NOVAHawk/system/request/Call_Instance?namespace=System/CommonMethods&" \
                            "class=QuotaMethods&instance=requested&#{attrs.join('&')}", @user)
  end

  def vm_attrs
    ["MiqRequest::miq_request=#{@miq_provision_request.id}"]
  end

  def service_attrs
    ["MiqRequest::miq_request=#{@service_request.id}&" \
     "vmdb_object_type=service_template_provision_request"]
  end

  def check_results(requested_hash, storage, cpu, vms, memory)
    expect(requested_hash[:storage]).to eq(storage)
    expect(requested_hash[:cpu]).to eq(cpu)
    expect(requested_hash[:vms]).to eq(vms)
    expect(requested_hash[:memory]).to eq(memory)
  end

  context "Service provisioning quota" do
    it "generic calculate_requested" do
      setup_model("generic")
      build_generic_service_item
      expect { run_automate_method(service_attrs) }.not_to raise_exception
    end

    it "generic ansible tower calculate_requested" do
      setup_model("generic")
      build_generic_ansible_tower_service_item
      expect { run_automate_method(service_attrs) }.not_to raise_exception
    end

    it "vmware service item calculate_requested" do
      setup_model("vmware")
      build_small_environment
      build_vmware_service_item
      ws = run_automate_method(service_attrs)
      check_results(ws.root['quota_requested'], 512.megabytes, 4, 1, 1.gigabytes)
    end
  end

  shared_examples_for "requested" do
    it "check" do
      setup_model("vmware")
      build_small_environment
      build_vmware_service_item
      @service_request.options[:dialog] = result_dialog
      @service_request.save
      expect(@service_request.options[:dialog]).to include(result_dialog)
      ws = run_automate_method(service_attrs)
      expect(ws.root['quota_requested']).to include(result_counts_hash)
    end
  end

  context "vmware service item with dialog override number_of_sockets = 3" do
    let(:result_counts_hash) do
      {:storage => 512.megabytes, :cpu => 6, :vms => 1, :memory => 1.gigabytes}
    end
    let(:result_dialog) do
      {"dialog_option_0_number_of_sockets" => "3"}
    end
    it_behaves_like "requested"
  end

  context "vmware service item with dialog override cores_per_socket = 4" do
    let(:result_counts_hash) do
      {:storage => 512.megabytes, :cpu => 8, :vms => 1, :memory => 1.gigabytes}
    end
    let(:result_dialog) do
      {"dialog_option_0_cores_per_socket" => "4"}
    end
    it_behaves_like "requested"
  end

  context "vmware service item with dialog override sockets = 3 and cores = 4 = 12" do
    let(:result_counts_hash) do
      {:storage => 512.megabytes, :cpu => 12, :vms => 1, :memory => 1.gigabytes}
    end
    let(:result_dialog) do
      {"dialog_option_0_number_of_sockets" => "3", "dialog_option_0_cores_per_socket" => "4"}
    end
    it_behaves_like "requested"
  end

  context "vmware service item with dialog override number_of_cpus = 5" do
    let(:result_counts_hash) do
      {:storage => 512.megabytes, :cpu => 5, :vms => 1, :memory => 1.gigabytes}
    end
    let(:result_dialog) do
      {"dialog_option_0_number_of_cpus" => "5"}
    end
    it_behaves_like "requested"
  end

  context "vmware service item with dialog override vm_memory = 2147483648" do
    let(:result_counts_hash) do
      {:storage => 512.megabytes, :cpu => 4, :vms => 1, :memory => 2.gigabytes}
    end
    let(:result_dialog) do
      {"dialog_option_0_vm_memory" => "2147483648"}
    end
    it_behaves_like "requested"
  end

  context "vmware service item with dialog override number_of_vms = 5" do
    let(:result_counts_hash) do
      {:storage => 512.megabytes, :cpu => 4, :vms => 5, :memory => 1.gigabytes}
    end
    let(:result_dialog) do
      {"dialog_option_0_number_of_vms" => "5"}
    end
    it_behaves_like "requested"
  end

  context "vmware service item with dialog override storage = 2147483648" do
    let(:result_counts_hash) do
      {:storage => 2.gigabytes, :cpu => 4, :vms => 1, :memory => 1.gigabytes}
    end
    let(:result_dialog) do
      {"dialog_option_0_storage" => "2147483648"}
    end
    it_behaves_like "requested"
  end

  context "Service Bundle provisioning quota" do
    it "Bundle of 2, google and vmware" do
      create_service_bundle([google_template, vmware_template])
      expect { run_automate_method(service_attrs) }.not_to raise_exception
    end

    it "Bundle of 2, google and generic" do
      create_service_bundle([google_template, generic_template])
      expect { run_automate_method(service_attrs) }.not_to raise_exception
    end
  end

  context "VM provisioning quota" do
    it "vmware calculate_requested" do
      setup_model("vmware")
      ws = run_automate_method(vm_attrs)
      check_results(ws.root['quota_requested'], 512.megabytes, 4, 1, 1.gigabytes)
    end

    it "google calculate_requested" do
      setup_model("google")
      ws = run_automate_method(vm_attrs)
      check_results(ws.root['quota_requested'], 10.gigabytes, 4, 1, 1024)
    end
  end

  context "VM provisioning multiple vms quota" do
    it "vmware calculate_requested number of vms 3" do
      setup_model("vmware")
      @miq_provision_request.options[:number_of_vms] = 3
      @miq_provision_request.save
      ws = run_automate_method(vm_attrs)
      check_results(ws.root['quota_requested'], 1536.megabytes, 12, 3, 3.gigabytes)
    end

    it "google calculate_requested number of vms 3" do
      setup_model("google")
      @miq_provision_request.options[:number_of_vms] = 3
      @miq_provision_request.save
      ws = run_automate_method(vm_attrs)
      check_results(ws.root['quota_requested'], 30.gigabytes, 12, 3, 3.kilobytes)
    end
  end

  context "VM Cloud provisioning with cloud volumes" do
    it "google calculate_requested number of vms 3, cloud volumes 3 gig " do
      setup_model("google")
      @miq_provision_request.options[:volumes] = [{:name => "Fred", :size => '1'}, {:name => "Wilma", :size => '2'}]
      @miq_provision_request.options[:number_of_vms] = 3
      @miq_provision_request.save
      ws = run_automate_method(vm_attrs)
      check_results(ws.root['quota_requested'], 39.gigabytes, 12, 3, 3.kilobytes)
    end
  end
end
