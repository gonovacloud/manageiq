FactoryGirl.define do
  factory :vm_vmware_cloud, :class => "NOVAHawk::Providers::Vmware::CloudManager::Vm", :parent => :vm_cloud do
    vendor "vmware"
  end
end
