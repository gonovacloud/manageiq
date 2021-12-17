FactoryGirl.define do
  factory :load_balancer_health_check do
    sequence(:name)    { |n| "load_balancer_health_check_#{seq_padded_for_sorting(n)}" }
    sequence(:ems_ref) { |n| "ems_ref_#{seq_padded_for_sorting(n)}" }
  end

  factory :load_balancer_health_check_amazon,
          :class  => "NOVAHawk::Providers::Amazon::NetworkManager::LoadBalancerHealthCheck",
          :parent => :load_balancer_health_check
end
