class RenameMiqSearchDb < ActiveRecord::Migration
  class MiqSearch < ActiveRecord::Base; end

  NAME_HASH = Hash[*%w(
    TemplateInfra NOVAHawk::Providers::InfraManager::Template
    VmInfra       NOVAHawk::Providers::InfraManager::Vm
    TemplateCloud NOVAHawk::Providers::CloudManager::Template
    VmCloud       NOVAHawk::Providers::CloudManager::Vm
  )]

  def up
    say_with_time("Rename MiqSearch db values") do
      MiqSearch.all.each do |search|
        search.update_attributes!(:db => NAME_HASH[search.db]) if NAME_HASH.key?(search.db)
      end
    end
  end
end
