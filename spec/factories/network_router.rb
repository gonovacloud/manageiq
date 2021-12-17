FactoryGirl.define do
  factory :network_router do
    sequence(:name)    { |n| "network_router_#{seq_padded_for_sorting(n)}" }
    sequence(:ems_ref) { |n| "ems_ref_#{seq_padded_for_sorting(n)}" }
  end

  factory :network_router_openstack, :class  => "NOVAHawk::Providers::Openstack::NetworkManager::NetworkRouter",
                                     :parent => :network_router
  factory :network_router_amazon, :class  => "NOVAHawk::Providers::Amazon::NetworkManager::NetworkRouter",
                                  :parent => :network_router
  factory :network_router_azure, :class  => "NOVAHawk::Providers::Azure::NetworkManager::NetworkRouter",
                                 :parent => :network_router
  factory :network_router_google, :class  => "NOVAHawk::Providers::Google::NetworkManager::NetworkRouter",
                                  :parent => :network_router
end
