# Copyright (c) 2010-2013 Ian Heggie, released under the MIT license.
# See MIT-LICENSE for details.

module HealthCheck

  if (defined?(Rails) and Rails.respond_to?(:version) && Rails.version =~ /^[3-9]/)
    class Engine < Rails::Engine
    end
  end
  #require 'health_check/add_3x_routes'

end

unless defined?(HealthCheck::Engine)
  require 'health_check/add_23_routes'
end

require 'health_check/utils'
require 'health_check/health_check_controller'

# vi: sw=2 sm ai:
