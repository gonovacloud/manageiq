FactoryGirl.define do
  factory :configuration_profile

  factory :configuration_profile_forman,
          :aliases => ["novahawk/providers/foreman/configuration_manager/configuration_profile"],
          :class   => "NOVAHawk::Providers::Foreman::ConfigurationManager::ConfigurationProfile",
          :parent  => :configuration_profile do
    name "foreman config profile"
  end
end
