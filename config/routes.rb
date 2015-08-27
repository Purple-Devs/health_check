if defined?(HealthCheck::Engine)
  unless HealthCheck::Engine.routes_already_defined
    # Ifmountable use: HealthCheck::Engine.routes.draw do
    Rails.application.routes.draw do
      health_check_routes()
    end
  end
end
