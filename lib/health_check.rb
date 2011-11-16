require 'health_check/health_check_class'
require 'health_check/health_check_controller'
if defined?(Rails) and Rails.respond_to?(:version) && Rails.version =~ /^3/
  require 'health_check/add_3x_routes'
else
  require 'health_check/add_23_routes'
end

