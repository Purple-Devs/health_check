require File.dirname(__FILE__) + '/../test_helper'

class RoutingTest < Test::Unit::TestCase

  def setup
    if defined?(Rails) and defined?(Rails.application) and Rails.application.routes
      Rails.application.routes.draw do |map|
	 # do nothing - routes should be added automatically
      end
    else
      ActionController::Routing::Routes.draw do |map|
	 # do nothing - routes should be added automatically
      end
    end
  end

  def test_health_check_plain_route
    assert_recognition :get, "/health_check", :controller => "health_check", :action => "index"
  end

  def test_health_check_checks_specified_route
    assert_recognition :get, "/health_check/two_checks", :controller => "health_check", :action => "check", :checks => 'two_checks'
  end

  private

  # yes, I know about assert_recognizes, but it has proven problematic to
  # use in these tests, since it uses RouteSet#recognize (which actually
  # tries to instantiate the controller) and because it uses an awkward
  # parameter order.
  def assert_recognition(method, path, options)
    if defined?(Rails) and defined?(Rails.application) and Rails.application.routes
      result = Rails.application.routes.recognize_path(path, :method => method)
    else
      result = ActionController::Routing::Routes.recognize_path(path, :method => method)
    end
    assert_equal options, result
  end

  # with Thanks to http://izumi.plan99.net/manuals/creating_plugins-8f53e4d6.html

end
