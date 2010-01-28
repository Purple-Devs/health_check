ENV['RAILS_ENV'] = 'test'

require 'test/unit'
require 'rubygems'

# Tests are conducted with health_test as a plugin
environment_file = File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'config', 'environment.rb')
if File.exists?(environment_file)
  # test as plugin
  require environment_file
else
  #tests as gem
  fail "TODO: Work out how to test as a gem (test as a plugin instead)"
  # TODO: Work out how to do this!
  #require 'rails/version'
  #RAILS_ROOT = "test" unless defined?(RAILS_ROOT)
  #module Rails
  #  def backtrace_cleaner(args)
  #    # do nothing
  #  end
  #end

  #require 'active_support'
  #require 'action_controller'
  #require 'action_controller/base'
  ##require 'action_controller/test_case'
  #require 'action_view'
  #require 'active_record'
  ##require 'active_support/backtrace_cleaner'
  ##require 'rails/backtrace_cleaner'

  #require 'test_help'
end


gem "shoulda"
require 'shoulda'
require 'shoulda/action_controller'

# rails test help

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

# gem init
#require 'health_check'

# plugin init
require File.join(File.dirname(__FILE__), '..', 'init')

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

EXAMPLE_SMTP_SETTINGS = {
  :address => "smtp.gmail.com",
  :domain => "test.example.com",
  :port => 587
}

ActionMailer::Base.delivery_method = :test

# Make sure sendmail settings are set to something that is executrable (we wont actually execute it)
sendmail_path = '/usr/sbin/sendmail'
['/bin/true', 'c:/windows/explorer.exe', 'c:/winnt/explorer.exe',
  File.join(RAILS_ROOT, 'script', 'about')].each do |f|
  sendmail_path = f if File.executable? f
end

EXAMPLE_SENDMAIL_SETTINGS = {
  :location => sendmail_path,
  :arguments => '--help'
}

def setup_db(version)
  ActiveRecord::Base.connection.initialize_schema_migrations_table
  ActiveRecord::Schema.define(:version => version) do
    create_table :kitchen do |t|
      t.column :owner, :string
      t.column :description, :string
    end
  end if version
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

