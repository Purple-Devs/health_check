if defined?(HealthCheck::Engine)
  Rails.application.routes.draw do
    match 'health_check', :to => 'health_check/health_check#index'
    match 'health_check/:checks', :to => 'health_check/health_check#check'
  end
end
