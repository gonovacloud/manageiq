class NOVAHawk::Providers::Vmware::NetworkManager::Refresher < NOVAHawk::Providers::BaseManager::Refresher
  include ::EmsRefresh::Refreshers::EmsRefresherMixin

  def parse_legacy_inventory(ems)
    NOVAHawk::Providers::Vmware::NetworkManager::RefreshParser.ems_inv_to_hashes(ems, refresher_options)
  end

  def post_process_refresh_classes
    []
  end
end
