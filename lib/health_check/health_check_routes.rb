if defined?(HealthCheck::Engine)

  module ActionDispatch::Routing
    class Mapper
      def health_check_routes(prefix = nil, manually_added=true)
        HealthCheck::Engine.routes_already_defined ||= manually_added
        get "#{prefix || 'health_check'}(/:checks)(.:format)", :to => 'health_check/health_check#index'
      end
    end
  end

end
