FactoryGirl.define do
  factory :vmware_refresh_worker, :class => 'NOVAHawk::Providers::Vmware::InfraManager::RefreshWorker' do
    pid { Process.pid }
  end
end
