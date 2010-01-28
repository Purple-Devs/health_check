require 'helper'

class HealthCheckControllerTest < ActionController::TestCase
  #context "HealthCheck plugin" do
  #   should_route :get, "/health_check", :controller => :health_check, :action => :index
  #    should_route :get, "/health_check/two_checks", :controller => :health_check, :action => :index, :checks => 'two_checks'
  #end

  context "GET standard on empty db" do
    setup do
      HealthCheck.db_migrate_path = File.join(File.dirname(__FILE__), 'migrate', 'empty')
      setup_db(nil)
      ActionMailer::Base.delivery_method = :test
      get :index
    end

    teardown do
      teardown_db
    end

    should_respond_with :success
    should_not_set_the_flash
    should_respond_with_content_type 'text/plain'
    should_render_without_layout
    should "return 'success' text" do
      assert_equal HealthCheck.success, @response.body
    end
  end

  context "GET migrations on db with migrations" do
    setup do
      HealthCheck.db_migrate_path = File.join(File.dirname(__FILE__), 'migrate', 'twelve')
      setup_db(12)
      ActionMailer::Base.delivery_method = :test
      get :check, :checks => 'migrations'
    end

    teardown do
      teardown_db
    end

    should_respond_with :success
    should_not_set_the_flash
    should_respond_with_content_type 'text/plain'
    should_render_without_layout
    should "return 'success' text" do
      assert_equal HealthCheck.success, @response.body
    end
  end

  context "GET standard with unactioned migrations" do
    setup do
      HealthCheck.db_migrate_path = File.join(File.dirname(__FILE__), 'migrate', 'twelve')
      setup_db(nil)
      ActionMailer::Base.delivery_method = :test
      get :index
    end

    teardown do
      teardown_db
    end

    should_respond_with 500
    should_not_set_the_flash
    should_respond_with_content_type 'text/plain'
    should_render_without_layout
    should "not return 'success' text" do
      assert_not_equal HealthCheck.success, @response.body
    end
  end

  context "GET email with :test" do
    setup do
      ActionMailer::Base.delivery_method = :test
      get :check, :checks => 'email'
    end

    should_respond_with :success
    should_not_set_the_flash
    should_respond_with_content_type 'text/plain'
    should_render_without_layout
    should "return 'success' text" do
      assert_equal HealthCheck.success, @response.body
    end
  end

  context "GET standard with bad smtp" do
    setup do
      HealthCheck.db_migrate_path = File.join(File.dirname(__FILE__), 'migrate', 'twelve')
      setup_db(12)
      HealthCheck.smtp_timeout = 2.0
      ActionMailer::Base.delivery_method = :smtp
      ActionMailer::Base.smtp_settings = {
        :address => "127.0.0.1",
        :domain => "testing.example.com",
        :port => 7
      }
      get :index
    end

    teardown do
      teardown_db
    end

    should_respond_with 500
    should_not_set_the_flash
    should_respond_with_content_type 'text/plain'
    should_render_without_layout
    should "not return 'success' text" do
      assert_not_equal HealthCheck.success, @response.body
    end
  end


  context "GET email with :smtp" do
    setup do
      # it should not care that the database isnt setup correctly
      HealthCheck.db_migrate_path = File.join(File.dirname(__FILE__), 'migrate', 'empty')
      setup_db(nil)
      ActionMailer::Base.delivery_method = :smtp
      HealthCheck.smtp_timeout = 60.0
      ActionMailer::Base.smtp_settings = EXAMPLE_SMTP_SETTINGS
      get :check, :checks => 'email'
    end

    should_respond_with :success
    should_respond_with_content_type 'text/plain'
    should "return 'success' text" do
      assert_equal HealthCheck.success, @response.body
    end
  end


  context "GET database_migration_email with missing sendmail" do
    setup do
      HealthCheck.db_migrate_path = File.join(File.dirname(__FILE__), 'migrate', 'twelve')
      setup_db(12)
      ActionMailer::Base.delivery_method = :sendmail
      ActionMailer::Base.sendmail_settings = { :location => '/no/such/executable', :arguments => '' }
      get :check, :checks => 'database_migration_email'
    end

    teardown do
      teardown_db
    end

    should_respond_with 500
    should_not_set_the_flash
    should_respond_with_content_type 'text/plain'
    should_render_without_layout
    should "not return 'success' text" do
      assert_not_equal HealthCheck.success, @response.body
    end
  end

  context "GET all with :sendmail" do
    setup do
      ActionMailer::Base.delivery_method = :sendmail
      ActionMailer::Base.sendmail_settings = EXAMPLE_SENDMAIL_SETTINGS
      HealthCheck.db_migrate_path = File.join(File.dirname(__FILE__), 'migrate', 'empty')
      setup_db(nil)
      get :check, :checks => 'all'
    end

    teardown do
      teardown_db
    end

    should_respond_with :success
    should_respond_with_content_type 'text/plain'
    should "return 'success' text" do
      assert_equal HealthCheck.success, @response.body
    end
  end
end
