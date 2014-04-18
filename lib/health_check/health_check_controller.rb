# Copyright (c) 2010-2013 Ian Heggie, released under the MIT license.
# See MIT-LICENSE for details.

module HealthCheck
  class HealthCheckController < ActionController::Base

    layout false if self.respond_to? :layout

    def index
      checks = params[:checks] || 'standard'
      begin
        errors = HealthCheck::Utils.process_checks(checks)
      rescue Exception => e
        errors = e.message
      end     
      if errors.blank?
        obj = { :healthy => true, :message => HealthCheck.success }
        respond_to do |format|
          format.html { render :text => HealthCheck.success, :content_type => 'text/plain' }
          format.json { render :xml => obj.to_json }
          format.xml { render :xml => obj.to_xml }
          format.any { render :text => HealthCheck.success, :content_type => 'text/plain' }
        end
      else
        msg = "health_check failed: #{errors}"
        obj = { :healthy => false, :message => msg }
        respond_to do |format|
          format.html { render :text => msg, :status => HealthCheck.http_status_for_error_text, :content_type => 'text/plain'  }
          format.json { render :xml => obj.to_json, :status => HealthCheck.http_status_for_error_object}
          format.xml { render :xml => obj.to_xml, :status => HealthCheck.http_status_for_error_object }
          format.any { render :text => msg, :status => HealthCheck.http_status_for_error_text, :content_type => 'text/plain'  }
        end
        # Log a single line as some uptime checkers only record that it failed, not the text returned
        if logger
          silence_level, logger.level = logger.level, @old_logger_level
          logger.info msg
          logger.level = silence_level
        end
      end
    end


    protected

    # turn cookies for CSRF off
    def protect_against_forgery?
      false
    end

    # Silence logger as much as we can

    if Rails.version < '4.1'

      def process_with_silent_log(method_name, *args)
        if logger
          @old_logger_level = logger.level
          if Rails.version >= '3.2'
            silence do
              process_without_silent_log(method_name, *args)
            end
          else
            logger.silence do
              process_without_silent_log(method_name, *args)
            end
          end
        else
          process_without_silent_log(method_name, *args)
        end
      end

      alias_method_chain :process, :silent_log

    end

  end
end
