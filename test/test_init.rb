ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= '_min'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'test_bench'; TestBench.activate

require 'pp'

require 'package_repository/debian/client/controls'

module PackageRepository
  module Debian
    module Client
      Controls = Module.new
    end
  end
end
include PackageRepository::Debian::Client
