FactoryGirl.define do
  factory :virtual_template, :class => 'NOVAHawk::Providers::CloudManager::VirtualTemplate' do
    name                    'a virtual template'
    description             'stores all arbitration decisions'
    ext_management_system   { FactoryGirl.create(:ems_cloud) }
  end

  factory :virtual_template_amazon, :class => 'NOVAHawk::Providers::Amazon::CloudManager::VirtualTemplate' do
    name                    'virtual template amazon'
    description             'a virtual template for amazon'
    ext_management_system   { FactoryGirl.create(:ems_amazon) }
    cloud_network           { FactoryGirl.create(:cloud_network_amazon) }
    availability_zone       { FactoryGirl.create(:availability_zone_amazon) }
    flavor                  { FactoryGirl.create(:flavor_amazon) }
    ems_ref                 'ami-1234'
  end

  factory :virtual_template_google, :class => 'NOVAHawk::Providers::Google::CloudManager::VirtualTemplate' do
    name                    'virtual template google'
    description             'a virtual template for google'
    ext_management_system   { FactoryGirl.create(:ems_google) }
    cloud_network           { FactoryGirl.create(:cloud_network_google) }
    availability_zone       { FactoryGirl.create(:availability_zone_google) }
    flavor                  { FactoryGirl.create(:flavor_google) }
    ems_ref                 'ami-1244'
  end
end
