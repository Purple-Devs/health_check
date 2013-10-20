if defined?(HealthCheck::Engine)
  unless HealthCheck::Engine.routes_manually_defined
    # Ifmountable use: HealthCheck::Engine.routes.draw do
    Rails.application.routes.draw do
      health_check_routes(false)
    end
  end
end
