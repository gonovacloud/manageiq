module NOVAHawk::Providers
  module Openshift
    class ContainerManager::Refresher < NOVAHawk::Providers::BaseManager::Refresher
      include ::EmsRefresh::Refreshers::EmsRefresherMixin
      include NOVAHawk::Providers::Kubernetes::ContainerManager::RefresherMixin

      KUBERNETES_EMS_TYPE = NOVAHawk::Providers::Kubernetes::ContainerManager.ems_type

      OPENSHIFT_ENTITIES = [
        {:name => 'routes'}, {:name => 'projects'},
        {:name => 'build_configs'}, {:name => 'builds'}, {:name => 'templates'}
      ]

      def parse_legacy_inventory(ems)
        request_entities = OPENSHIFT_ENTITIES.dup
        request_entities << {:name => 'images'} if refresher_options.get_container_images

        kube_entities = ems.with_provider_connection(:service => KUBERNETES_EMS_TYPE) do |kubeclient|
          fetch_entities(kubeclient, KUBERNETES_ENTITIES)
        end
        openshift_entities = ems.with_provider_connection do |openshift_client|
          fetch_entities(openshift_client, request_entities)
        end
        entities = openshift_entities.merge(kube_entities)
        EmsRefresh.log_inv_debug_trace(entities, "inv_hash:")
        NOVAHawk::Providers::Openshift::ContainerManager::RefreshParser.ems_inv_to_hashes(entities, refresher_options)
      end
    end
  end
end
