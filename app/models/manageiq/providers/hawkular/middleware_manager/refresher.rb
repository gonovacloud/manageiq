module NOVAHawk::Providers::Hawkular
  class MiddlewareManager::Refresher < NOVAHawk::Providers::BaseManager::Refresher
    include ::EmsRefresh::Refreshers::EmsRefresherMixin

    def parse_legacy_inventory(ems)
      ::NOVAHawk::Providers::Hawkular::MiddlewareManager::RefreshParser.ems_inv_to_hashes(ems)
    end
  end
end
