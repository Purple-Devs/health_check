module HealthCheck
  class Engine < ::Rails::Engine
    cattr_accessor :routes_explicitly_defined
  end
end
