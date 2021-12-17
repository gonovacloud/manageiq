module NOVAHawk::Providers::Openshift::ContainerManagerMixin
  extend ActiveSupport::Concern

  include NOVAHawk::Providers::Kubernetes::ContainerManagerMixin

  DEFAULT_PORT = 8443

  included do
    has_many :container_routes, :foreign_key => :ems_id, :dependent => :destroy
    default_value_for :port do |provider|
      provider.port || DEFAULT_PORT
    end
  end

  # This is the API version that we use and support throughout the entire code
  # (parsers, events, etc.). It should be explicitly selected here and not
  # decided by the user nor out of control in the defaults of openshift gem
  # because it's not guaranteed that the next default version will work with
  # our specific code in NOVAHawk.
  delegate :api_version, :to => :class

  def api_version=(_value)
    raise 'OpenShift api_version cannot be modified'
  end

  class_methods do
    def api_version
      'v1'
    end

    def raw_connect(hostname, port, options)
      options[:service] ||= "openshift"
      send("#{options[:service]}_connect", hostname, port, options)
    end

    def openshift_connect(hostname, port, options)
      require 'kubeclient'

      Kubeclient::Client.new(
        raw_api_endpoint(hostname, port, '/oapi'),
        api_version,
        :ssl_options    => { :verify_ssl => verify_ssl_mode },
        :auth_options   => kubernetes_auth_options(options),
        :http_proxy_uri => VMDB::Util.http_proxy_uri,
        :timeouts       => {
          :open => Settings.ems.ems_kubernetes.open_timeout.to_f_with_method,
          :read => Settings.ems.ems_kubernetes.read_timeout.to_f_with_method
        }
      )
    end
  end
end
