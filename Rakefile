require "bundler/gem_tasks"

#require 'rubygems'
require 'rake'

#tests as gem
task :test do
  exec '/bin/bash', './test/test_with_railsapp'
end

task default: :test

begin
  gem 'rdoc'
  require 'rdoc/task'

  Rake::RDocTask.new do |rdoc|
    version = HealthCheck::VERSION

    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "health_check #{version}"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('CHANGELOG')
    rdoc.rdoc_files.include('MIT-LICENSE')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue Gem::LoadError
  puts "rdoc (or a dependency) not available. Install it with: gem install rdoc"
end
