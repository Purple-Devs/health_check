if defined?(HealthCheck::Engine)
  Rails.application.routes.draw do
    health_check_routes
  end
end
