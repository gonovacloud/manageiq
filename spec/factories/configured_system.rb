FactoryGirl.define do
  factory :configured_system do
    sequence(:name) { |n| "Configured_system_#{seq_padded_for_sorting(n)}" }
  end

  factory :configured_system_foreman,
          :class  => "NOVAHawk::Providers::Foreman::ConfigurationManager::ConfiguredSystem",
          :parent => :configured_system

  factory :configured_system_ansible_tower,
          :class  => "NOVAHawk::Providers::AnsibleTower::ConfigurationManager::ConfiguredSystem",
          :parent => :configured_system
end
