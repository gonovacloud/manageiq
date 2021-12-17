module NOVAHawk::Providers
  class StorageManager::SwiftManager::Refresher < NOVAHawk::Providers::BaseManager::Refresher
    include ::EmsRefresh::Refreshers::EmsRefresherMixin

    def parse_legacy_inventory(ems)
      NOVAHawk::Providers::StorageManager::SwiftManager::RefreshParser.ems_inv_to_hashes(ems, refresher_options)
    end

    def post_process_refresh_classes
      []
    end
  end
end
