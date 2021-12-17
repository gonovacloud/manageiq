class NOVAHawk::Providers::InfraManager::Template < MiqTemplate
  default_value_for :cloud, false

  def self.eligible_for_provisioning
    super.where(:type => %w(NOVAHawk::Providers::Redhat::InfraManager::Template NOVAHawk::Providers::Vmware::InfraManager::Template NOVAHawk::Providers::Microsoft::InfraManager::Template))
  end

  private

  def raise_created_event
    MiqEvent.raise_evm_event(self, "vm_template", :vm => self, :host => host)
  end
end
