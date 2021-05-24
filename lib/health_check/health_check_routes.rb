module ActionDispatch::Routing
  class Mapper

    def health_check_routes(prefix = nil)
      HealthCheck::Engine.routes_explicitly_defined = true
      add_health_check_routes(prefix)
    end

    def add_health_check_routes(prefix = nil)
      HealthCheck.uri = prefix if prefix
      match "#{HealthCheck.uri}(/:checks)(.:format)", controller: 'health_check/health_check', action: :index, via: [:get, :post], defaults: { format: 'txt' }
    end

  end
end
