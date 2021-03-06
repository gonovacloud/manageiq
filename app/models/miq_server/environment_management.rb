require 'miq_apache'
require 'linux_admin'

module MiqServer::EnvironmentManagement
  extend ActiveSupport::Concern

  module ClassMethods
    # Spartan mode used for testing only.
    #   minimal - Runs with 1 worker monitor, 1 generic, and 1 priority worker only
    #             Can also specify other specific worker types, to start a single
    #               worker, via underscore separation, e.g. minimal_schedule to start
    #               1 schedule worker.
    def spartan_mode
      @spartan_mode ||= ENV["MIQ_SPARTAN"].to_s.strip
    end

    def minimal_env?
      spartan_mode.start_with?("minimal")
    end

    def normal_env?
      !self.minimal_env?
    end

    MIQ_SPARTAN_ROLE_SEPARATOR = ":"
    def minimal_env_options
      @minimal_env_options ||= begin
        minimal_env? ? spartan_mode.split(MIQ_SPARTAN_ROLE_SEPARATOR)[1..-1] : []
      end
    end

    def startup_mode
      mode = ""
      # Find out startup mode
      if self.minimal_env?
        mode = "Minimal"
        mode << " [#{minimal_env_options.join(', ')}]" unless minimal_env_options.empty?
      else
        mode = "Normal"
      end

      mode
    end

    def get_network_information
      ipaddr = hostname = mac_address = nil
      begin
        if MiqEnvironment::Command.is_appliance?
          eth0 = LinuxAdmin::NetworkInterface.new("eth0")

          ipaddr      = eth0.address
          hostname    = LinuxAdmin::Hosts.new.hostname
          mac_address = eth0.mac_address
        else
          require 'MiqSockUtil'
          ipaddr      = MiqSockUtil.getIpAddr
          hostname    = MiqSockUtil.getFullyQualifiedDomainName
          mac_address = MiqUUID.mac_address.dup
        end
      rescue
      end

      [ipaddr, hostname, mac_address]
    end

    def validate_database
      ActiveRecord::Base.connection.reconnect!

      # Log the Versions
      _log.info "Database Adapter: [#{ActiveRecord::Base.connection.adapter_name}], version: [#{ActiveRecord::Base.connection.database_version}]"                   if ActiveRecord::Base.connection.respond_to?(:database_version)
      _log.info "Database Adapter: [#{ActiveRecord::Base.connection.adapter_name}], detailed version: [#{ActiveRecord::Base.connection.detailed_database_version}]" if ActiveRecord::Base.connection.respond_to?(:detailed_database_version)
    end

    def start_memcached
      # TODO: Need to periodically check the memcached instance to see if it's up, and bounce it and notify the UiWorkers to re-connect
      return unless ::Settings.server.session_store.to_s == 'cache'
      return unless MiqEnvironment::Command.supports_memcached?
      require "#{Rails.root}/lib/miq_memcached" unless Object.const_defined?(:MiqMemcached)
      _svr, port = ::Settings.session.memcache_server.to_s.split(":")
      opts = ::Settings.session.memcache_server_opts.to_s
      MiqMemcached::Control.restart!(:port => port, :options => opts)
      _log.info("Status: #{MiqMemcached::Control.status[1]}")
    end

    def prep_apache_proxying
      return unless MiqEnvironment::Command.supports_apache?

      MiqUiWorker.install_apache_proxy_config
      MiqWebServiceWorker.install_apache_proxy_config
      MiqWebsocketWorker.install_apache_proxy_config

      # Because adding balancer members does a validation of the configuration
      # files and these files try to load the redirect files among others,
      # we need to add the balancers members after all configuration files have
      # been written by install_apache_proxy_config.
      MiqUiWorker.add_apache_balancer_members
      MiqWebServiceWorker.add_apache_balancer_members
      MiqWebsocketWorker.add_apache_balancer_members

      MiqApache::Control.restart
    end
  end

  #
  # Apache
  #
  def queue_restart_apache
    MiqQueue.put_unless_exists(
      :class_name  => 'MiqServer',
      :instance_id => id,
      :method_name => 'restart_apache',
      :queue_name  => 'miq_server',
      :zone        => zone.name,
      :server_guid => guid
    ) do |msg|
      _log.info("Server: [#{id}] [#{name}], there is already a prior request to restart apache, skipping...") unless msg.nil?
    end
  end

  def restart_apache
    MiqApache::Control.restart(false)
  end

  def start_apache
    MiqApache::Control.start
  end

  def stop_apache
    MiqApache::Control.stop(false)
  end

  def disk_usage_threshold
    ::Settings.server.events.disk_usage_gt_percent || 80
  end

  def check_disk_usage(disks)
    threshold = disk_usage_threshold

    disks.each do |disk|
      next unless disk[:used_bytes_percent].to_i > threshold
      disk_usage_event = case disk[:mount_point].chomp
                         when '/'                then 'evm_server_system_disk_high_usage'
                         when '/boot'            then 'evm_server_boot_disk_high_usage'
                         when '/home'            then 'evm_server_home_disk_high_usage'
                         when '/var'             then 'evm_server_var_disk_high_usage'
                         when '/var/log'         then 'evm_server_var_log_disk_high_usage'
                         when '/var/log/audit'   then 'evm_server_var_log_audit_disk_high_usage'
                         when '/var/www/miq_tmp' then 'evm_server_miq_tmp_disk_high_usage'
                         when '/tmp'             then 'evm_server_tmp_disk_high_usage'
                         when %r{lib/pgsql}      then 'evm_server_db_disk_high_usage'
                         end

      next unless disk_usage_event
      msg = "Filesystem: #{disk[:filesystem]} (#{disk[:type]}) on #{disk[:mount_point]} is #{disk[:used_bytes_percent]}% full with #{ActionView::Base.new.number_to_human_size(disk[:available_bytes])} free."
      MiqEvent.raise_evm_event_queue(self, disk_usage_event, :event_details => msg)
    end
  end
end
