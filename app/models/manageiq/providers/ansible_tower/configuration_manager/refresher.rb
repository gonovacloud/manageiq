module NOVAHawk::Providers
  module AnsibleTower
    class ConfigurationManager::Refresher < NOVAHawk::Providers::BaseManager::Refresher
      include ::EmsRefresh::Refreshers::EmsRefresherMixin

      def parse_legacy_inventory(configuration_manager)
        configuration_manager.with_provider_connection do |connection|
          # TODO clean up with @ems_data
          configuration_manager.api_version = connection.api.version
          configuration_manager.save
        end

        NOVAHawk::Providers::AnsibleTower::ConfigurationManager::RefreshParser.configuration_manager_inv_to_hashes(configuration_manager, refresher_options)
      end
    end
  end
end
