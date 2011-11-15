if defined?(Rails) and Rails.respond_to?(:version) && Rails.version =~ /^3/
  if defined? Rails31
    Rails31::Application.routes.draw do
      match 'health_check', :to => 'health_check#index'
      match 'health_check/:checks', :to => 'health_check#check'
    end
  else
    Rails.application.routes.draw do |map|
      match 'health_check', :to => 'health_check#index'
      match 'health_check/:checks', :to => 'health_check#check'
    end
  end
end
