FactoryGirl.define do
  factory :flavor do
    sequence(:name) { |n| "flavor_#{seq_padded_for_sorting(n)}" }
  end

  factory :flavor_openstack, :parent => :flavor, :class => "NOVAHawk::Providers::Openstack::CloudManager::Flavor" do
    root_disk_size 1_073_741_824
  end

  factory :flavor_amazon,    :parent => :flavor, :class => "NOVAHawk::Providers::Amazon::CloudManager::Flavor"
  factory :flavor_google,    :parent => :flavor, :class => "NOVAHawk::Providers::Google::CloudManager::Flavor"
  factory :flavor_azure,     :parent => :flavor, :class => "NOVAHawk::Providers::Azure::CloudManager::Flavor"
end
