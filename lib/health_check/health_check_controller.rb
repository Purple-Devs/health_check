# Copyright (c) 2010-2013 Ian Heggie, released under the MIT license.
# See MIT-LICENSE for details.

module HealthCheck
  class HealthCheckController < ActionController::Base

    layout false if self.respond_to? :layout
    before_action :check_origin_ip
    before_action :authenticate

    def index
      last_modified = Time.now.utc
      max_age = HealthCheck.max_age
      if max_age > 1
        last_modified = Time.at((last_modified.to_f / max_age).floor * max_age).utc
      end
      public = (max_age > 1) && ! HealthCheck.basic_auth_username
      if stale?(:last_modified => last_modified, :public => public)
        checks = params[:checks] ? params[:checks].split('_') : ['standard']
        checks -= HealthCheck.middleware_checks if HealthCheck.installed_as_middleware
        begin
          errors = HealthCheck::Utils.process_checks(checks)
        rescue Exception => e
          errors = e.message.blank? ? e.class.to_s : e.message.to_s
        end
        response.headers['Cache-control'] = (public ? 'public' : 'private') + ', no-cache, must-revalidate' + (max_age > 0 ? ", max-age=#{max_age}" : '')
        if errors.blank?
          send_response true, nil, :ok, :ok
        else
          msg = HealthCheck.include_error_in_response_body ? "health_check failed: #{errors}" : nil
          send_response false, msg, HealthCheck.http_status_for_error_text, HealthCheck.http_status_for_error_object
          # Log a single line as some uptime checkers only record that it failed, not the text returned
          if logger
            logger.info msg
          end
        end
      end
    end

    protected

    def send_response(healthy, msg, text_status, obj_status)
      msg ||= healthy ? HealthCheck.success : HealthCheck.failure
      obj = { :healthy => healthy, :message => msg}
      respond_to do |format|
        format.html { render :plain => msg, :status => text_status, :content_type => 'text/plain' }
        format.json { render :json => obj, :status => obj_status }
        format.xml { render :xml => obj, :status => obj_status }
        format.any { render :plain => msg, :status => text_status, :content_type => 'text/plain' }
      end
    end

    def authenticate
      return unless HealthCheck.basic_auth_username && HealthCheck.basic_auth_password
      authenticate_or_request_with_http_basic('Health Check') do |username, password|
        username == HealthCheck.basic_auth_username && password == HealthCheck.basic_auth_password
      end
    end

    def check_origin_ip
      unless HealthCheck.origin_ip_allowlist_cidr.blank? ||
          HealthCheck.origin_ip_allowlist_cidr.any? { |cidr| cidr.matches?(req_ip) }
        render :plain => 'Health check is not allowed for the requesting IP',
               :status => HealthCheck.http_status_for_ip_whitelist_error,
               :content_type => 'text/plain'
      end
    end

    # turn cookies for CSRF off
    def protect_against_forgery?
      false
    end

  end
end
