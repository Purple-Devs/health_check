if defined?(HealthCheck::Engine)

  module ActionDispatch::Routing
    class Mapper
      def health_check_routes
        unless HealthCheck::Engine.routes_defined
          HealthCheck::Engine.routes_defined = true
          get 'health_check', :to => 'health_check/health_check#index'
          get 'health_check.:format', :to => 'health_check/health_check#index'
          get 'health_check/:checks', :to => 'health_check/health_check#index'
          get 'health_check/:checks.:format', :to => 'health_check/health_check#index'
        end
      end
    end
  end

end
