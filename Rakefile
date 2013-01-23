require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "health_check"
    gem.summary = %Q{Simple health check of Rails app}
    gem.description = %Q{Simple health check of Rails app for use with uptime.openacs.org or wasitup.com}
    gem.email = "ian@heggie.biz"
    gem.homepage = "http://github.com/ianheggie/health_check"
    gem.authors = ["Ian Heggie"]
    # Gemfile contains gem dependencies, apart from bundler itself
    gem.add_development_dependency 'bundler', '~> 1.2.0'
    gem.files.exclude 'gemfiles/*', '.travis.yml'

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new

  #task :test => :check_dependencies
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

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
    version = File.exist?('VERSION') ? File.read('VERSION') : ""

    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "health_check #{version}"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue Gem::LoadError
  puts "rdoc (or a dependency) not available. Install it with: gem install rdoc"
end
