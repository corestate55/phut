# frozen_string_literal: true
require 'phut'

Before do
  @log_dir = './log'
  @pid_dir = './tmp/pids'
  @socket_dir = './tmp/sockets'
end

Before('@sudo') do
  raise 'sudo authentication failed' unless system 'sudo -v'
  @aruba_timeout_seconds = 10
end

After('@sudo') do
  Aruba.configure do |config|
    Dir.chdir(config.working_directory) do
      Phut.pid_dir = @pid_dir
      Phut.log_dir = @log_dir
      Phut.socket_dir = @socket_dir
      # FIXME: Delete me
      TearDownParser.new.parse(@config_file).stop
      Phut::Vswitch.destroy_all
      Phut::Vhost.destroy_all
      Phut::Link.destroy_all
    end
  end
end

Before('@shell') do
  raise 'sudo authentication failed' unless system 'sudo -v'
end

After('@shell') do
  `sudo ovs-vsctl list-br`.split("\n").each do |each|
    run "sudo ovs-vsctl del-br #{each}"
  end
end
