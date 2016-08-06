# Copyright (c) 2010-2013 Ian Heggie, released under the MIT license.
# See MIT-LICENSE for details.

module HealthCheck

  if Rails.version >= '3.0'
    class Engine < Rails::Engine
      cattr_accessor :routes_manually_defined
    end
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

  #
  mattr_accessor :basic_auth_username, :basic_auth_password
  self.basic_auth_username = nil
  self.basic_auth_password = nil

  # s3 buckets
  mattr_accessor :buckets
  self.buckets = {}

  # Array of custom check blocks
  mattr_accessor :custom_checks
  mattr_accessor :full_checks
  mattr_accessor :standard_checks
  self.custom_checks = [ ]
  self.full_checks = ['database', 'migrations', 'custom', 'email', 'cache', 'redis', 'sidekiq-redis', 'resque-redis', 's3']
  self.standard_checks = [ 'database', 'migrations', 'custom' ]

  def self.add_custom_check(&block)
    custom_checks << block
  end
  
  def self.setup
    yield self
  end

end

require "health_check/version"
require 'health_check/base_health_check'
require 'health_check/resque_health_check'
require 'health_check/s3_health_check'
require 'health_check/redis_health_check'
require 'health_check/elasticsearch_health_check'
require 'health_check/sidekiq_health_check'
require 'health_check/utils'
require 'health_check/health_check_controller'

if defined?(HealthCheck::Engine)
  require 'health_check/health_check_routes'
else
  require 'health_check/add_23_routes'
end

# vi: sw=2 sm ai:
