# Copyright (c) 2010-2013 Ian Heggie, released under the MIT license.
# See MIT-LICENSE for details.

module HealthCheck

  class Engine < ::Rails::Engine
    cattr_accessor :routes_explicitly_defined
  end

  # Log level
  mattr_accessor :log_level
  self.log_level = 'info'

  # Text output upon success
  mattr_accessor :success
  self.success = "success"

  # Text output upon failure
  mattr_accessor :failure
  self.failure = "health_check failed"

  # Timeout in seconds used when checking smtp server
  mattr_accessor :smtp_timeout
  self.smtp_timeout = 30.0

  # http status code used when plain text error message is output
  mattr_accessor :http_status_for_error_text
  self.http_status_for_error_text = 500

  # http status code used when an error object is output (json or xml)
  mattr_accessor :http_status_for_error_object
  self.http_status_for_error_object = 500

  # http status code used when the ip is not allowed for the request
  mattr_accessor :http_status_for_ip_whitelist_error
  self.http_status_for_ip_whitelist_error = 403

  # check remote_ip rather than ip for ip whitelist
  mattr_accessor :accept_proxied_requests
  self.accept_proxied_requests = false

  # ips allowed to perform requests
  mattr_accessor :origin_ip_whitelist
  self.origin_ip_whitelist = []

  # max-age of response in seconds
  # cache-control is public when max_age > 1 and basic authentication is used
  mattr_accessor :max_age
  self.max_age = 1

  # s3 buckets
  mattr_accessor :buckets
  self.buckets = {}

  # rabbitmq
  mattr_accessor :rabbitmq_config
  self.rabbitmq_config = {}

  # health check uri path
  mattr_accessor :uri
  self.uri = 'health_check'

  # Basic Authentication
  mattr_accessor :basic_auth_username, :basic_auth_password
  self.basic_auth_username = nil
  self.basic_auth_password = nil

  # Array of custom check blocks
  mattr_accessor :custom_checks
  mattr_accessor :full_checks
  mattr_accessor :standard_checks
  self.custom_checks = { }
  self.full_checks = ['database', 'migrations', 'custom', 'email', 'cache', 'redis-if-present', 'sidekiq-redis-if-present', 'resque-redis-if-present', 's3-if-present', 'elasticsearch-if-present']
  self.standard_checks = [ 'database', 'migrations', 'custom', 'emailconf' ]

  # Middleware based checks
  mattr_accessor :middleware_checks
  self.middleware_checks = [ 'middleware' ]

  mattr_accessor :installed_as_middleware

  # Allow non-standard redis url and password
  mattr_accessor :redis_url
  self.redis_url = ENV['REDIS_URL']

  mattr_accessor :redis_password
  self.redis_password = 'some-password'

  # Include the error in the response body. 
  # You should only do this where your /health_check endpoint is NOT open to the public internet
  mattr_accessor :include_error_in_response_body
  self.include_error_in_response_body = false

  # used for on_failure and on_success
  mattr_accessor :success_callbacks
  mattr_accessor :failure_callbacks

  def self.add_custom_check(name = 'custom', &block)
    custom_checks[name] ||= [ ]
    custom_checks[name] << block
  end

  def self.on_success(&block)
    success_callbacks ||= [ ]
    success_callbacks << block
  end

  def self.on_failure(&block)
    failure_callbacks ||= [ ]
    failure_callbacks << block
  end

  def self.setup
    yield self
  end

end

require 'health_check/version'
require 'health_check/base_health_check'
require 'health_check/resque_health_check'
require 'health_check/s3_health_check'
require 'health_check/redis_health_check'
require 'health_check/elasticsearch_health_check'
require 'health_check/sidekiq_health_check'
require 'health_check/utils'
require 'health_check/health_check_controller'
require 'health_check/health_check_routes'
require 'health_check/middleware_health_check'
require 'health_check/rabbitmq_health_check'

# vi: sw=2 sm ai:
