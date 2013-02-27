require "bundler/gem_tasks"

#require 'rubygems'
require 'rake'

# Tests are conducted with health_test as a plugin
environment_file = File.join(File.dirname(__FILE__), '..', '..', '..', 'config', 'environment.rb')
plugin_dir = File.join(File.dirname(__FILE__), '..', 'plugins')

if File.exists?(environment_file) and File.directory?(plugin_dir)
  # test as plugin
  
  require 'rake/testtask'
  Rake::TestTask.new(:test) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end

  begin
    require 'rcov/rcovtask'
    Rcov::RcovTask.new do |test|
      test.libs << 'test'
      test.pattern = 'test/**/*_test.rb'
      test.verbose = true
    end
  rescue LoadError
    task :rcov do
      abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
    end
  end

else
  #tests as gem
  task :test do
    exec '/bin/bash', './test/test_with_railsapp'
  end
end

task :default => :test

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
