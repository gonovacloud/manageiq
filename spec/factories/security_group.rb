FactoryGirl.define do
  factory :security_group do
    sequence(:name) { |n| "security_group_#{seq_padded_for_sorting(n)}" }
  end

  factory :security_group_amazon, :parent => :security_group,
                                  :class  => "NOVAHawk::Providers::Amazon::NetworkManager::SecurityGroup"
  factory :security_group_openstack, :parent => :security_group,
                                     :class  => "NOVAHawk::Providers::Openstack::NetworkManager::SecurityGroup"
  factory :security_group_azure, :parent => :security_group,
                                 :class  => "NOVAHawk::Providers::Azure::NetworkManager::SecurityGroup"
  factory :security_group_google, :parent => :security_group,
                                  :class  => "NOVAHawk::Providers::Google::NetworkManager::SecurityGroup"
end
