FactoryGirl.define do
  factory :template_azure, :class => "NOVAHawk::Providers::Azure::CloudManager::Template", :parent => :template_cloud do
    location { |x| "#{x.name}/#{x.name}.img.manifest.xml" }
    vendor   "azure"
  end
end
