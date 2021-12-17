FactoryGirl.define do
  factory :container do
  end

  factory :kubernetes_container,
          :aliases => ['app/models/novahawk/providers/kubernetes/container_manager/container'],
          :class   => 'NOVAHawk::Providers::Kubernetes::ContainerManager::Container',
          :parent  => :container do
  end
end
