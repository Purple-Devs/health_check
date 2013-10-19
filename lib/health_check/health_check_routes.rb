if defined?(HealthCheck::Engine)

  module ActionDispatch::Routing
    class Mapper
      def health_check_routes(routes_manually_defined = true)
        HealthCheck::Engine.routes_manually_defined ||= routes_manually_defined
        get 'health_check', :to => 'health_check/health_check#index'
        get 'health_check.:format', :to => 'health_check/health_check#index'
        get 'health_check/:checks', :to => 'health_check/health_check#index'
        get 'health_check/:checks.:format', :to => 'health_check/health_check#index'
      end
    end
  end

end
