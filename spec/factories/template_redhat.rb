FactoryGirl.define do
  factory(:template_redhat, :class => "NOVAHawk::Providers::Redhat::InfraManager::Template", :parent => :template_infra) { vendor "redhat" }
end
