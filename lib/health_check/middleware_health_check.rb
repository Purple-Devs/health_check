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
        if response_type == 'xml'
          content_type = 'text/xml'
          msg = { healthy: healthy, message: msg }.to_xml
        elsif response_type == 'json'
          content_type = 'application/json'
          msg = { healthy: healthy, message: msg }.to_json
        else
          content_type = 'text/plain'
        end
        [ (healthy ? 200 : 500), { 'Content-Type' => content_type }, [msg] ]
      else
        @app.call(env)
      end
    end

  end
end
