# Copyright (c) 2010-2013 Ian Heggie, released under the MIT license.
# See MIT-LICENSE for details.

module HealthCheck
end

require 'health_check/utils'
require 'health_check/health_check_controller'
if defined?(Rails) and Rails.respond_to?(:version) && Rails.version =~ /^3/
  require 'health_check/add_3x_routes'
else
  require 'health_check/add_23_routes'
end

