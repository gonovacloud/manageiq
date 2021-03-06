require 'pid_file'

class EvmApplication
  include Vmdb::Logging

  def self.start
    if server_state == :no_db
      puts "EVM has no Database connection"
      File.open(Rails.root.join("tmp", "pids", "evm.pid"), "w") { |f| f.write("no_db") }
      exit
    end

    if pid = MiqServer.running?
      puts "EVM is already running (PID=#{pid})"
      exit
    end

    puts "Starting EVM..."
    _log.info("EVM Startup initiated")

    MiqServer.kill_all_workers
    command_line = "#{Gem.ruby} #{Rails.root.join(*%w(lib workers bin evm_server.rb)).expand_path}"

    env_options = {}
    env_options["EVMSERVER"] = "true" if MiqEnvironment::Command.is_appliance?
    puts "Running EVM in background..."
    pid = Kernel.spawn(env_options, command_line, :pgroup => true, [:out, :err] => [Rails.root.join("log/evm.log"), "a"])
    Process.detach(pid)
  end

  def self.stop
    puts "Stopping EVM gracefully..."
    _log.info("EVM Shutdown initiated")
    MiqServer.stop(true)
  end

  def self.kill
    puts "Killing EVM..."
    _log.info("EVM Kill initiated")
    MiqServer.kill
  end

  def self.server_state
    MiqServer.my_server.status
  rescue => error
    :no_db if error.message =~ /Connection refused/i
  end

  def self.status
    puts "Checking EVM status..."
    server = MiqServer.my_server(true)
    if server.nil?
      puts "Local EVM Server not Found"
    else
      output_servers_status([server])
      puts "\n"
      output_workers_status(server.miq_workers)
    end
  end

  def self.output_servers_status(servers)
    data = servers.collect do |s|
      [s.zone.name,
       s.name,
       s.status,
       s.id,
       s.pid,
       s.sql_spid,
       s.drb_uri,
       s.started_on && s.started_on.iso8601,
       s.last_heartbeat && s.last_heartbeat.iso8601,
       s.active_role_names.join(':')
      ]
    end
    header = ["Zone", "Server Name", "Status", "ID", "PID", "SPID", "URL", "Started On", "Last Heartbeat", "Active Roles"]
    puts data.unshift(header).tableize
  end

  def self.output_workers_status(workers)
    data = workers.sort_by(&:type).collect do |w|
      [w.type,
       w.status.sub("stopping", "stop pending"),
       w.id,
       w.pid,
       w.sql_spid,
       w.queue_name || w.uri,
       w.started_on && w.started_on.iso8601,
       w.last_heartbeat && w.last_heartbeat.iso8601
      ]
    end
    header = ["Worker Type", "Status", "ID", "PID", "SPID", "Queue Name / URL", "Started On", "Last Heartbeat"]
    puts data.unshift(header).tableize unless data.empty?
  end

  def self.update_start
    require 'fileutils'
    filename = MiqServer.pidfile
    tempfile = "#{filename}.yum"
    FileUtils.mkdir_p(File.dirname(filename))
    File.write(filename, "no_db") if File.file?(tempfile)
    FileUtils.rm_f(tempfile)
  end

  def self.update_stop
    return if MiqServer.my_server.status != "started"

    require 'fileutils'
    tempfile = "#{MiqServer.pidfile}.yum"
    FileUtils.mkdir_p(File.dirname(tempfile))
    File.write(tempfile, " ")
    stop
  end

  def self.set_region_file(region_file, new_region)
    old_region = region_file.exist? ? region_file.read.to_i : nil

    return if new_region == old_region

    _log.info("Changing REGION file from [#{old_region}] to [#{new_region}]. Restart to use the new region.")
    region_file.write(new_region)
  end
end
