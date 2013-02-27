source 'https://rubygems.org'

# Specify your gem's dependencies in health_check.gemspec

gemspec

group :development, :test do
  if defined?(JRUBY_VERSION)
    gem 'jruby-openssl'
    gem 'activerecord-jdbcsqlite3-adapter'
  else
    gem 'sqlite3', "~> 1.3.7"
  end
end

group :misc do
  # run travis-lint to check .travis.yml
  gem 'travis-lint'
  # required to run rake test:plugins
  #gem 'ruby-prof', '>= 0.6.1'
end

