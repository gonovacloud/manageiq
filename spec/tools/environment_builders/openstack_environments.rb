require 'fog/openstack'
# TODO(lsmola) how do I load this?
# require 'models/ems_refresh/refreshers/openstack/refresh_spec_environments'

$LOAD_PATH.push(Rails.root.to_s)
require_relative 'openstack/helper_methods'

include Openstack::HelperMethods

def usage(s)
  $stderr.puts(s)
  $stderr.puts("Usage: bundle exec rails rspec/tools/environment_builders/openstack_environments.rb --load")
  $stderr.puts("- loads credentials for enviroments.yaml to all refresh tests and VCRs")
  $stderr.puts("Usage: bundle exec rails rspec/tools/environment_builders/openstack_environments.rb --obfuscate")
  $stderr.puts("- obfuscates all credentials in tests and VCRs")
  exit(2)
end

@method = ARGV.shift
unless %w(--load --obfuscate --activate-paginations --deactivate-paginations).include?(@method)
  raise ArgumentError, usage("expecting method name as first argument")
end

OBFUSCATED_PASSWORD = "password_2WpEraURh"
OBFUSCATED_IP = "11.22.33.44"

def load_environments
  openstack_environments.each do |env|
    env_name = env.keys.first
    env      = env[env_name]

    puts "-------------------------------------------------------------------------------------------------------------"
    puts "Loading enviroment credentials for #{env_name}"
    file_name = File.join(test_base_dir, "refresher_rhos_#{env_name}_spec.rb")
    change_file(file_name, OBFUSCATED_PASSWORD, env["password"], OBFUSCATED_IP, env["ip"])

    file_name = File.join(vcr_base_dir, "refresher_rhos_#{env_name}_with_errors.yml")
    change_file(file_name, OBFUSCATED_PASSWORD, env["password"], OBFUSCATED_IP, env["ip"])

    file_name = File.join(vcr_base_dir, "refresher_rhos_#{env_name}.yml")
    change_file(file_name, OBFUSCATED_PASSWORD, env["password"], OBFUSCATED_IP, env["ip"])

    file_name = File.join(vcr_base_dir, "refresher_rhos_#{env_name}_legacy_fast_refresh.yml")
    change_file(file_name, OBFUSCATED_PASSWORD, env["password"], OBFUSCATED_IP, env["ip"])
  end
end

def obfuscate_environments
  openstack_environments.each do |env|
    env_name = env.keys.first
    env      = env[env_name]

    puts "-------------------------------------------------------------------------------------------------------------"
    puts "Obfuscating enviroment credentials for #{env_name}"
    file_name = File.join(test_base_dir, "refresher_rhos_#{env_name}_spec.rb")
    change_file(file_name, env["password"], OBFUSCATED_PASSWORD, env["ip"], OBFUSCATED_IP)

    file_name = File.join(vcr_base_dir, "refresher_rhos_#{env_name}_with_errors.yml")
    change_file(file_name, env["password"], OBFUSCATED_PASSWORD, env["ip"], OBFUSCATED_IP)

    file_name = File.join(vcr_base_dir, "refresher_rhos_#{env_name}.yml")
    change_file(file_name, env["password"], OBFUSCATED_PASSWORD, env["ip"], OBFUSCATED_IP)

    file_name = File.join(vcr_base_dir, "refresher_rhos_#{env_name}_legacy_fast_refresh.yml")
    change_file(file_name, env["password"], OBFUSCATED_PASSWORD, env["ip"], OBFUSCATED_IP)
  end
end

def activate_paginations
  openstack_environments.each do |env|
    env_name     = env.keys.first
    env          = env[env_name]
    ssh_user     = env["ssh_user"] || "root"

    @environment = env_name.to_sym

    case @environment
    when :grizzly
      puts " We don't support pagination for grizzly"
      next
    when :havana
      file = "openstack-activate-pagination-rhel6"
    else
      file = "openstack-activate-pagination"
    end

    puts "-------------------------------------------------------------------------------------------------------------"
    puts "Activate paginations in installed OpenStack #{env_name}"
    cmd = " ssh #{ssh_user}@#{env["ip"]} "\
          " 'curl http://file.brq.redhat.com/~lsmola/miq/#{file} | bash -x' "
    puts cmd
    ` #{cmd} `
  end
end

def deactivate_paginations
  openstack_environments.each do |env|
    env_name     = env.keys.first
    env          = env[env_name]
    ssh_user     = env["ssh_user"] || "root"

    @environment = env_name.to_sym

    puts "-------------------------------------------------------------------------------------------------------------"
    case @environment
    when :grizzly
      puts " We don't support pagination for grizzly"
      next
    when :havana
      file = "openstack-deactivate-pagination-rhel6"
    else
      file = "openstack-deactivate-pagination"
    end

    puts "Deactivate paginations in installed OpenStack #{env_name}"
    cmd = " ssh #{ssh_user}@#{env["ip"]} "\
          " 'curl http://file.brq.redhat.com/~lsmola/miq/#{file} | bash -x' "
    puts cmd
    ` #{cmd} `
  end
end

def change_file(file_name, from_password, to_password, from_ip, to_ip)
  return unless File.exist?(file_name)

  file = File.read(file_name)
  file.gsub!(from_password, to_password)
  file.gsub!(from_ip, to_ip)

  File.open(file_name, 'w') do |out|
    out << file
  end
end

case @method
when "--load"
  load_environments
when "--obfuscate"
  obfuscate_environments
when "--activate-paginations"
  activate_paginations
when "--deactivate-paginations"
  deactivate_paginations
end
