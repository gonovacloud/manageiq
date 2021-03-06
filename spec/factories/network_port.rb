FactoryGirl.define do
  factory :network_port do
    sequence(:name)    { |n| "cloud_network_#{seq_padded_for_sorting(n)}" }
    sequence(:ems_ref) { |n| "ems_ref_#{seq_padded_for_sorting(n)}" }
  end

  factory :network_port_openstack, :class  => "NOVAHawk::Providers::Openstack::NetworkManager::NetworkPort",
                                   :parent => :network_port
  factory :network_port_amazon, :class  => "NOVAHawk::Providers::Amazon::NetworkManager::NetworkPort",
                                :parent => :network_port
  factory :network_port_azure, :class  => "NOVAHawk::Providers::Azure::NetworkManager::NetworkPort",
                               :parent => :network_port
  factory :network_port_google, :class  => "NOVAHawk::Providers::Google::NetworkManager::NetworkPort",
                                :parent => :network_port
end
