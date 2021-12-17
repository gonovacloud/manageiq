FactoryGirl.define do
  factory :cloud_volume do
  end

  factory :cloud_volume_amazon, :class => "NOVAHawk::Providers::Amazon::CloudManager::CloudVolume", :parent => :cloud_volume do
  end

  factory :cloud_volume_openstack, :class => "NOVAHawk::Providers::Openstack::CloudManager::CloudVolume", :parent => :cloud_volume do
    status "available"
  end
end
