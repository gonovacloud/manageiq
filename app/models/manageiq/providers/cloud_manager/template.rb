class NOVAHawk::Providers::CloudManager::Template < ::MiqTemplate
  default_value_for :cloud, true

  def self.eligible_for_provisioning
    super.where(:type => %w(NOVAHawk::Providers::Amazon::CloudManager::Template
                            NOVAHawk::Providers::Openstack::CloudManager::Template
                            NOVAHawk::Providers::Azure::CloudManager::Template
                            NOVAHawk::Providers::Google::CloudManager::Template))
  end

  private

  def raise_created_event
    MiqEvent.raise_evm_event(self, "vm_template", :vm => self)
  end
end
