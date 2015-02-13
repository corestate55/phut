require 'phut/cli'
require 'phut/settings'
require 'pio/mac'
require 'rake'

module Phut
  # An interface class to phost emulation utility program.
  class Phost
    include FileUtils

    attr_reader :ip
    attr_reader :name
    attr_reader :mac
    attr_accessor :interface

    def initialize(ip_address, promisc, name = nil)
      @ip = ip_address
      @promisc = promisc
      @name = name || @ip
      @mac = Pio::Mac.new(rand(0xffffffffffff + 1))
    end

    def run(hosts = [])
      sh "sudo #{executable} #{options.join ' '}",
         verbose: Phut.settings[:verbose]
      sleep 1
      set_ip_and_mac_address
      maybe_enable_promisc
      add_arp_entries hosts
    end

    def stop
      pid = IO.read(pid_file)
      sh "sudo kill #{pid}", verbose: Phut.settings[:verbose]
      loop { break unless running? }
    end

    def netmask
      '255.255.255.255'
    end

    def running?
      FileTest.exists?(pid_file)
    end

    private

    def set_ip_and_mac_address
      Phut::Cli.new(self).set_ip_and_mac_address
    end

    def maybe_enable_promisc
      return unless @promisc
      Phut::Cli.new(self).enable_promisc
    end

    def add_arp_entries(hosts)
      hosts.each do |each|
        Phut::Cli.new(self).add_arp_entry each
      end
    end

    def pid_file
      "#{Phut.settings[:pid_dir]}/phost.#{name}.pid"
    end

    def executable
      "#{Phut::ROOT}/vendor/phost/src/phost"
    end

    def options
      %W(-p #{Phut.settings[:pid_dir]}
         -l #{Phut.settings[:log_dir]}
         -n #{name}
         -i #{interface}
         -D)
    end
  end
end
