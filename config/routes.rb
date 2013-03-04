if defined?(HealthCheck::Engine)
  Rails.application.routes.draw do
    get 'health_check', :to => 'health_check/health_check#index'
    get 'health_check.:format', :to => 'health_check/health_check#index'
    get 'health_check/:checks', :to => 'health_check/health_check#index'
    get 'health_check/:checks.:format', :to => 'health_check/health_check#index'
  end
end
