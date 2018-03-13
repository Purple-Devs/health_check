source 'https://rubygems.org'

# Specify your gem's dependencies in health_check.gemspec

# TODO: fix shoulda version doesn't work with ruby 2.2
ruby '1.9.3' if RUBY_VERSION > '1.9.3'

gemspec

# mime-types 2.0 requires Ruby version >= 1.9.2
gem "mime-types", "< 2.0" if RUBY_VERSION < '1.9.2' # REQUIRED
# 0.7 requires ruby 1.9.3
gem 'i18n', '< 0.7' if RUBY_VERSION < '1.9.3' # REQUIRED
# rack 2.0 requires ruby 2.2.2, rails 3.2 requires rack ~> 1.4.5
gem 'rack', "< 1.5" # REQUIRED

gem 'rack-cache', '< 1.3' if RUBY_VERSION < '1.9.3'

group :development, :test do
  if defined?(JRUBY_VERSION)
    gem 'jruby-openssl'
    gem 'activerecord-jdbcsqlite3-adapter'
  else
    gem 'sqlite3', "~> 1.3.7"
  end
  # run travis-lint to check .travis.yml
  gem 'travis-lint'
  #gem 'rake', ">= 0.8.3", "< 11.0"
  #gem 'rack', "< 2.0"

end

gem 'json', [">=0", "< 2.0.0"] if RUBY_VERSION < '1.9.3' # REQUIRED - Added by SmarterBundler
