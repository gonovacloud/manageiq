class NOVAHawk::Providers::Vmware::CloudManager::Refresher < NOVAHawk::Providers::BaseManager::Refresher
  include ::EmsRefresh::Refreshers::EmsRefresherMixin

  def parse_legacy_inventory(ems)
    NOVAHawk::Providers::Vmware::CloudManager::RefreshParser.ems_inv_to_hashes(ems, refresher_options)
  end

  def save_inventory(ems, target, hashes)
    super
    EmsRefresh.queue_refresh(ems.network_manager)
  end

  def post_process_refresh_classes
    [::Vm]
  end
end
