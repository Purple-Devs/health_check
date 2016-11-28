module HealthCheck
  class MiddlewareHealthcheck

    def initialize(app)
      @app = app
    end

    def call(env)
      uri = env['PATH_INFO']
      if uri =~ /^\/#{Regexp.escape HealthCheck.uri}(\/([-_0-9a-zA-Z]*))?(\.(\w*))?$/
        checks = $2.to_s == '' ? ['standard'] : $2.split('_')
        response_type = $4
        HealthCheck.installed_as_middleware = true
        errors = ''
        middleware_checks = checks & HealthCheck.middleware_checks
        full_stack_checks = (checks - HealthCheck.middleware_checks) - ['and']
        object_error_code = HealthCheck.http_status_for_error_object
        text_error_code = HealthCheck.http_status_for_error_text
        req = Rack::Request.new(env)
        extra_headers = { }
        if ip_ok(env)
          if authenticated(env)
            begin
              # Process the checks to be run from middleware
              errors = HealthCheck::Utils.process_checks(middleware_checks, true)
              # Process remaining checks through the full stack if there are any
              unless full_stack_checks.empty?
                return @app.call(env)
              end
            rescue => e
              errors = e.message.blank? ? e.class.to_s : e.message.to_s
            end
            healthy = errors.blank?
            msg = healthy ? HealthCheck.success : "health_check failed: #{errors}"
          else
            healthy = false
            msg = 'Authentication required'
            text_error_code = object_error_code = 401
            extra_headers = { 'WWW-Authenticate' => 'Basic realm="Health Check"' }
          end
        else
          healthy = false
          msg = 'Health check is not allowed for the requesting IP'
          text_error_code = HealthCheck.http_status_for_ip_whitelist_error_text
          object_error_code = HealthCheck.http_status_for_ip_whitelist_error_object
        end

        if response_type == 'xml'
          content_type = 'text/xml'
          msg = { healthy: healthy, message: msg }.to_xml
          error_code = object_error_code
        elsif response_type == 'json'
          content_type = 'application/json'
          msg = { healthy: healthy, message: msg }.to_json
          error_code = object_error_code
        else
          content_type = 'text/plain'
          error_code = text_error_code
        end
        [ (healthy ? 200 : error_code), { 'Content-Type' => content_type }.merge(extra_headers), [msg] ]
      else
        @app.call(env)
      end
    end

    protected

    def ip_ok(env)
      return true if HealthCheck.origin_ip_whitelist.blank?
      req = Rack::Request.new(env)
      HealthCheck.origin_ip_whitelist.include?(req.ip)
    end

    def authenticated(env)
      auth = MiddlewareHealthcheck::Request.new(env)
      return false unless auth.provided? && auth.basic?
      if Rack::Utils.secure_compare(HealthCheck.basic_auth_username, auth.username) && Rack::Utils.secure_compare(HealthCheck.basic_auth_password, auth.password)
        env['REMOTE_USER'] = auth.username
        return true
      end
      false
    end

    class Request < Rack::Auth::AbstractRequest
      def basic?
        "basic" == scheme
      end

      def credentials
        @credentials ||= params.unpack("m*").first.split(/:/, 2)
      end

      def username
        credentials.first
      end

      def password
        credentials.last
      end
    end

  end
end
