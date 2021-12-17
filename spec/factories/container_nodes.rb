FactoryGirl.define do
  factory :container_node do
    after(:create) do |x|
      x.computer_system = FactoryGirl.create(:computer_system)
    end
  end

  factory :kubernetes_node,
          :aliases => ['app/models/novahawk/providers/kubernetes/container_manager/container_node'],
          :class   => 'NOVAHawk::Providers::Kubernetes::ContainerManager::ContainerNode',
          :parent  => :container_node do
  end
end
