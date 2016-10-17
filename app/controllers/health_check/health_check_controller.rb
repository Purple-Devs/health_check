# Copyright (c) 2010-2013 Ian Heggie, released under the MIT license.
# See MIT-LICENSE for details.

module HealthCheck
  class HealthCheckController < ActionController::Base

    layout false if self.respond_to? :layout
    before_action :authenticate

    def index
      last_modified = Time.now.utc
      max_age = HealthCheck.max_age
      if max_age > 0
        last_modified = Time.at((last_modified.to_f / max_age).floor * max_age).utc
      end
      public = (max_age > 1) && ! HealthCheck.basic_auth_username
      if stale?(:last_modified => last_modified, :public => public)
        # Rails 4.0 doesn't have :plain, but it is deprecated later on
        plain_key = Rails.version < '4.1' ? :text : :plain
        html_key = Rails.version < '4.1' ? :text : :html
        checks = params[:checks] || 'standard'
        begin
          errors = HealthCheck::Utils.process_checks(checks)
        rescue Exception => e
          errors = e.message.blank? ? e.class.to_s : e.message.to_s
        end     
        # response.headers['Cache-control'] = (public ? 'public' : 'private') + ', no-cache, must-revalidate' + (max_age > 0 ? ", max-age=#{max_age}" : '')
        # response.cache_control[:'max-age'] = max_age if max_age >= 1
        # response.cache_control[:'no-cache'] = true if max_age < 1
        # response.cache_control[:'must-revalidate'] = true if max_age >= 1

        @healthy = errors.blank?
        @title = @healthy ? 'PASS' : 'FAIL'
        if @healthy
          @msg = HealthCheck.success
          text_status = object_status = 200
        else
          @msg = "health_check failed: #{errors}"
          text_status = HealthCheck.http_status_for_error_text
          object_status = HealthCheck.http_status_for_error_object
          # Log a single line as some uptime checkers only record that it failed, not the text returned
          if logger
            logger.info @msg
          end
        end
        obj = { :healthy => @healthy, :message => @msg }
        respond_to do |format|
          format.html { render '/health_check/health_check/index.html.erb', layout:false, :content_type => 'text/html', :status => text_status }
          format.json { render :json => obj, :status => object_status}
          format.xml { render :xml => obj, :status => object_status}
          format.any { render '/health_check/health_check/index.txt.erb', layout:false, :content_type => 'text/plain', :status => text_status }
        end
      end
    end


    protected

    def authenticate
      return unless HealthCheck.basic_auth_username && HealthCheck.basic_auth_password
      authenticate_or_request_with_http_basic do |username, password|
        username == HealthCheck.basic_auth_username && password == HealthCheck.basic_auth_password
      end
    end

    # turn cookies for CSRF off
    def protect_against_forgery?
      false
    end

  end
end
