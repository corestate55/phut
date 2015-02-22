require 'tmpdir'

# Base module.
module Phut
  # Central configuration repository.
  class Setting
    DEFAULTS = {
      root: File.expand_path(File.join(__dir__, '..', '..')),
      pid_dir: Dir.tmpdir,
      log_dir: Dir.tmpdir,
      socket_dir: Dir.tmpdir
    }

    def initialize
      @options = DEFAULTS.dup
    end

    def root
      @options.fetch :root
    end

    def pid_dir
      @options.fetch :pid_dir
    end

    def pid_dir=(path)
      @options[:pid_dir] = File.expand_path(path)
    end

    def log_dir
      @options.fetch :log_dir
    end

    def log_dir=(path)
      @options[:log_dir] = File.expand_path(path)
    end

    def socket_dir
      @options.fetch :socket_dir
    end

    def socket_dir=(path)
      @options[:socket_dir] = File.expand_path(path)
    end
  end

  SettingSingleton = Setting.new

  class << self
    def method_missing(method, *args)
      SettingSingleton.__send__ method, *args
    end
  end
end