# Copyright (c) 2010-2013 Ian Heggie, released under the MIT license.
# See MIT-LICENSE for details.

module HealthCheck

  class Engine < Rails::Engine
    cattr_accessor :routes_already_defined
  end

  # Text output upon success
  mattr_accessor :success
  self.success = "success"

  # Timeout in seconds used when checking smtp server
  mattr_accessor :smtp_timeout
  self.smtp_timeout = 30.0

  # http status code used when plain text error message is output
  mattr_accessor :http_status_for_error_text
  self.http_status_for_error_text = 500

  # http status code used when an error object is output (json or xml)
  mattr_accessor :http_status_for_error_object
  self.http_status_for_error_object = 500

  # Array of custom check blocks
  mattr_accessor :custom_checks
  mattr_accessor :full_checks
  mattr_accessor :standard_checks
  self.custom_checks = [ ]
  self.full_checks = ['database', 'migrations', 'custom', 'email', 'cache']
  self.standard_checks = [ 'database', 'migrations', 'custom', 'emailconf' ]

  def self.add_custom_check(&block)
    custom_checks << block
  end

  def self.setup
    yield self
  end

end

require "health_check/version"
require 'health_check/utils'
require 'health_check/health_check_controller'
require 'health_check/health_check_routes'

# vi: sw=2 sm ai:
