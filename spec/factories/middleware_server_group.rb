FactoryGirl.define do
  factory :middleware_server_group do
    sequence(:name) { |n| "middleware_server_group_#{seq_padded_for_sorting(n)}" }
  end

  factory :hawkular_middleware_server_group,
          :aliases => ['app/models/novahawk/providers/hawkular/middleware_manager/middleware_server_group'],
          :class   => 'NOVAHawk::Providers::Hawkular::MiddlewareManager::MiddlewareServerGroup',
          :parent  => :middleware_server_group do
  end
end
