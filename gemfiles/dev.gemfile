# Gemfile for health_test

source 'https://rubygems.org'

gem 'rails', ">= 2.3.0"

group :development, :test do
  gem 'rake', '>= 0.8.3'
  gem 'jeweler', '~> 1.8.4'
  gem 'shoulda', "~> 2.11.0"
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
  gem 'ruby-prof', '>= 0.6.1'
end

