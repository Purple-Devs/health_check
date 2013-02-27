# health\_check gem

Simple health check of Rails app for use with Pingdom, NewRelic, EngineYard or uptime.openacs.org etc.

The basic goal is to quickly check that rails is up and running and that it has access to correctly configured resources (database, email gateway)

health_check provides various monitoring URIs, for example:

    curl localhost:3000/health_check
    success

    curl localhost:3000/health_check/all
    success

    curl localhost:3000/health_check/database_cache_migration
    success

The health_check controller disables sessions and logging for its actions to minimise the impact of frequent uptime checks on the session store and the log file.

## Checks

* standard (default) - site, database and migrations checks are run plus email if settings have been changed
* all / full - all checks are run
* database - checks that the current migration level can be read from the database
* email - basic check of email - :test returns true, :sendmail checks file is present and executable, :smtp sends HELO command to server and checks response
* migration - checks that the database migration level matches that in db/migrations
* cache - checks that a value can be written to the cache
* site - checks rails is running sufficiently to render text

The email gateway is not checked unless the smtp settings have been changed.
Specify full or include email in the list of checks to varify the smtp settings
(eg use 127.0.0.1 instead of localhost).

## Installation

### As a Gem from rubygems (Rails 3.0 and above)

Add the following line to Gemfile

    gem "health_check"

And then execute

    bundle

Or install it yourself as:

    gem install health_check

### As a Gem from rubygems (Rails 2.3)

Install the gem using the following command

    gem install health_check

Then add the following line to config/environment.rb within the config block

    config.gem "health_check"

### As a Plugin (Rails 2.3.x)

Run the following commands from the root of your rails application

    cd vendor/plugins
    git clone git://github.com/ianheggie/health_check.git

## Uptime Monitoring

Use a website monitoring service to check the url regularly for the word "success" (without the quotes) rather than just a 200 http status so
that any substitution of a different server or generic information page should also be reported as an error.

If an error is encounted, the text "health_check failed: some error message/s" will be returned and the http status will be 500.

See

* Pingdom Website Monitoring - https://www.pingdom.com
* NewRelic Availability Monitoring - http://newrelic.com/docs/features/availability-monitoring-faq
* Uptime by OpenACS - http://uptime.openacs.org/uptime/
* Engine Yard's guide - https://support.cloud.engineyard.com/entries/20996821-monitor-application-uptime (although the guide is based on fitter_happier plugin it will also work with this gem)
* Any other montoring service that can be set to check for the word success in the test returned from a url

## Note on Patches/Pull Requests

_Feedback welcome! Especially with suggested replacement code and corresponding tests_

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request.

## Known Issues

* No inline documentation for methods
* <b>rvm gemsets breaks the test</b> - specifically `rvm use 1.9.3` works but `rvm gemset use ruby-1.9.3-p385@health_check --create`
triggers a "Could not find gem 'coffee-rails (~> 3.2.1) ruby' in the gems available on this machine." error in the last call to bundle (installing health_check as a gem via a path into the temp railsapp)

## Similar projects

* fitter_happier plugin by atmos - plugin with similar goals, but not compatible with uptime, and does not check email gateway


## Testing

### Automated continuous integration tests

See Travis CI testing result: [<img src="https://travis-ci.org/ianheggie/health_check.png" />](https://travis-ci.org/ianheggie/health_check)

### Manual testing

The test will package up and install the gem under a temporary path, create a dummy rails app configured for sqlite,
install the gem, and then run up tests against the server.
This will require TCP port 3456 to be free.

Using rbenv or rvm, install and set the version of ruby you wish to test against.
You will need to install the bundler gem if using rbenv.
See the `.travis.yml` file for a list of supported ruby versions.

* rbenv command: `rbenv shell 1.8.7-p371`
* rvm command: `rvm use 1.9.3`

Create a temp directory for throw away testing, and clone the health_check gem into it

    mkdir -p ~/tmp
    cd ~/tmp
    git clone https://github.com/ianheggie/health_check.git

All of the following commands should be run under the checked out gem

    cd ~/tmp/health_check

Configure which rails version you want to test against, and load the gems appropriate for the ruby version - use one of the following commands:

    export BUNDLE_GEMFILE=$PWD/rails2_3.gemfile
    export BUNDLE_GEMFILE=$PWD/rails3_0.gemfile
    export BUNDLE_GEMFILE=$PWD/rails3_1.gemfile
    export BUNDLE_GEMFILE=$PWD/rails3_2.gemfile
    unset BUNDLE_GEMFILE # for installed version of rails

Then install the required gems, and update rbenv shims (if using rbenv)

    bundle install --binstubs
    rbenv rehash

Run the tests

    bin/rake test

## Copyright

Copyright (c) 2010-2013 Ian Heggie, released under the MIT license.
See [MIT-LICENSE](MIT-LICENSE) for details.

