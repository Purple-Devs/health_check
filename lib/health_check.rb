# Copyright (c) 2010-2013 Ian Heggie, released under the MIT license.
# See MIT-LICENSE for details.

module HealthCheck

  if Rails.version >= '3.0'
    class Engine < Rails::Engine
    end
  end

  # Text output upon success
  mattr_accessor :success
  self.success = "success"

  # Timeout in seconds used when checking smtp server
  mattr_accessor :smtp_timeout
  self.smtp_timeout = 30.0

  def self.setup
    yield self
  end

end

require 'health_check/utils'
require 'health_check/health_check_controller'

unless defined?(HealthCheck::Engine)
  require 'health_check/add_23_routes'
end

# vi: sw=2 sm ai:
