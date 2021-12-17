describe EmsInfra do
  it ".types" do
    expected_types = [NOVAHawk::Providers::Vmware::InfraManager, NOVAHawk::Providers::Redhat::InfraManager, NOVAHawk::Providers::Microsoft::InfraManager, NOVAHawk::Providers::Openstack::InfraManager].collect(&:ems_type)
    expect(described_class.types).to match_array(expected_types)
  end

  it ".supported_subclasses" do
    expected_subclasses = [NOVAHawk::Providers::Vmware::InfraManager, NOVAHawk::Providers::Microsoft::InfraManager, NOVAHawk::Providers::Redhat::InfraManager, NOVAHawk::Providers::Openstack::InfraManager]
    expect(described_class.supported_subclasses).to match_array(expected_subclasses)
  end

  it ".supported_types" do
    expected_types = [NOVAHawk::Providers::Vmware::InfraManager, NOVAHawk::Providers::Microsoft::InfraManager, NOVAHawk::Providers::Redhat::InfraManager, NOVAHawk::Providers::Openstack::InfraManager].collect(&:ems_type)
    expect(described_class.supported_types).to match_array(expected_types)
  end
end
