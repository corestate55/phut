# frozen_string_literal: true
require 'phut/link'
require 'phut/netns'
require 'phut/syntax/netns_directive'
require 'phut/syntax/vhost_directive'
require 'phut/syntax/vswitch_directive'
require 'phut/vhost'

module Phut
  # DSL syntax definitions.
  class Syntax
    def initialize(netns)
      @netns = netns
    end

    def vswitch(alias_name = nil, &block)
      attrs = VswitchDirective.new(alias_name, &block)
      Vswitch.create(dpid: attrs[:dpid],
                     name: attrs[:name],
                     tcp_port: attrs[:port])
    end

    def vhost(name = nil, &block)
      attrs = VhostDirective.new(name, &block)
      Vhost.create(name: attrs[:name],
                   ip_address: attrs[:ip],
                   mac_address: attrs[:mac],
                   promisc: attrs[:promisc])
    end

    def link(name_a, name_b)
      Link.create(name_a, name_b)
    end

    def netns(name, &block)
      @netns << NetnsDirective.new(name, &block)
    end
  end
end
