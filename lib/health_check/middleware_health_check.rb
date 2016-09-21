module HealthCheck
  class MiddlewareHealthcheck

    def initialize(app)
      @app = app
    end

    def call(env)
      uri = env['PATH_INFO']
      if uri.include? HealthCheck.uri
        response_type = uri[/\.(json|xml)/,1] || 'plain'
        response_method = 'response_' + response_type
        checks = env['QUERY_STRING'][/checks=([a-z0-9\-_]*)/,1] || 'standard'
        begin
          errors = HealthCheck::Utils.process_checks(checks)
        rescue => e
          errors = e.message.blank? ? e.class.to_s : e.message.to_s
        end
        if errors.blank?
          send(response_method, 200, HealthCheck.success, true)
        else
          msg = "health_check failed: #{errors}"
          send(response_method, 500, msg, false)
        end
      else
        @app.call(env)
      end
    end

    def response_json code, msg, healthy
      obj = { healthy: healthy, message: msg }
      [ code, { 'Content-Type' => 'application/json' }, [obj.to_json] ]
    end

    def response_xml code, msg, healthy
      obj = { healthy: healthy, message: msg }
      [ code, { 'Content-Type' => 'text/xml' }, [obj.to_xml] ]
    end

    def response_plain code, msg, healthy
      [ code, { 'Content-Type' => 'text/plain' }, [msg] ]
    end
  end
end
