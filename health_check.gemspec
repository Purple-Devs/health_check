# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'health_check/version'

Gem::Specification.new do |gem|
  gem.name          = "health_check"
  gem.version       = HealthCheck::VERSION
  gem.required_rubygems_version = Gem::Requirement.new(">= 0") if gem.respond_to? :required_rubygems_version=
  gem.authors       = ["Ian Heggie"]
  gem.email         = ["ian@heggie.biz"]
  gem.summary = %q{Simple health check of Rails app for uptime monitoring with Pingdom, NewRelic, EngineYard or uptime.openacs.org etc.}
  gem.description = <<-EOF
  	Simple health check of Rails app for uptime monitoring with Pingdom, NewRelic, EngineYard or uptime.openacs.org etc.
  EOF
  gem.homepage      = "https://github.com/ianheggie/health_check"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.extra_rdoc_files = [ "README.rdoc" ]
  gem.require_paths = ["lib"]
  gem.required_ruby_version = '>= 1.9.3'
  gem.add_dependency(%q<rails>, [">= 4.0"])
  gem.add_development_dependency(%q<rake>, [">= 0.8.3"])
  gem.add_development_dependency(%q<shoulda>, ["~> 2.11.0"])
  gem.add_development_dependency(%q<bundler>, ["~> 1.2"])
end
