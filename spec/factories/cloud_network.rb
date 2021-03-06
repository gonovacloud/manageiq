FactoryGirl.define do
  factory :cloud_network do
    sequence(:name)    { |n| "cloud_network_#{seq_padded_for_sorting(n)}" }
    sequence(:ems_ref) { |n| "ems_ref_#{seq_padded_for_sorting(n)}" }
  end

  factory :cloud_network_openstack, :class  => "NOVAHawk::Providers::Openstack::NetworkManager::CloudNetwork",
                                    :parent => :cloud_network
  factory :cloud_network_private_openstack,
          :class  => "NOVAHawk::Providers::Openstack::NetworkManager::CloudNetwork::Private",
          :parent => :cloud_network_openstack
  factory :cloud_network_public_openstack,
          :class  => "NOVAHawk::Providers::Openstack::NetworkManager::CloudNetwork::Public",
          :parent => :cloud_network_openstack
  factory :cloud_network_amazon, :class  => "NOVAHawk::Providers::Amazon::NetworkManager::CloudNetwork",
                                 :parent => :cloud_network
  factory :cloud_network_azure, :class  => "NOVAHawk::Providers::Azure::NetworkManager::CloudNetwork",
                                :parent => :cloud_network
  factory :cloud_network_google, :class  => "NOVAHawk::Providers::Google::NetworkManager::CloudNetwork",
                                 :parent => :cloud_network
end
