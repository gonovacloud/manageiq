FactoryGirl.define do
  factory :host_service_group_openstack, :class => "NOVAHawk::Providers::Openstack::InfraManager::HostServiceGroup" do
    sequence(:name) { |n| "host_service_group_openstack_#{seq_padded_for_sorting(n)}" }
  end
end
