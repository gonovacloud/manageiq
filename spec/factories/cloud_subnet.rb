FactoryGirl.define do
  factory :cloud_subnet do
    sequence(:name)    { |n| "cloud_subnet_#{seq_padded_for_sorting(n)}" }
    sequence(:ems_ref) { |n| "ems_ref_#{seq_padded_for_sorting(n)}" }
  end

  factory :cloud_subnet_openstack, :class  => "NOVAHawk::Providers::Openstack::NetworkManager::CloudSubnet",
                                   :parent => :cloud_subnet
  factory :cloud_subnet_amazon, :class  => "NOVAHawk::Providers::Amazon::NetworkManager::CloudSubnet",
                                :parent => :cloud_subnet
  factory :cloud_subnet_azure, :class  => "NOVAHawk::Providers::Azure::NetworkManager::CloudSubnet",
                               :parent => :cloud_subnet
  factory :cloud_subnet_google, :class  => "NOVAHawk::Providers::Google::NetworkManager::CloudSubnet",
                                :parent => :cloud_subnet
end
