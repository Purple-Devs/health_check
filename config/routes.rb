if defined?(HealthCheck::Engine)
  #Rails.application.routes.draw do
  unless HealthCheck::Engine.routes_manually_defined
    # Ifmountable use: HealthCheck::Engine.routes.draw do
    Rails.application.draw do
      health_check_routes(false)
    end
  end
end
