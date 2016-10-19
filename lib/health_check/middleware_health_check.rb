module HealthCheck
  class MiddlewareHealthcheck

    def initialize(app)
      @app = app
    end

    def call(env)
      if env['PATH_INFO'] =~ /^\/?#{HealthCheck.uri}\/?([-_0-9a-zA-Z]*)(\.(\w*))?/
        response_type = $3 || 'plain'
        begin
          start_time = Process.clock_gettime(Benchmark::BENCHMARK_CLOCK)
          @app.call(env)
        rescue Exception => exception
          msg = exception.message.blank? ? exception.class.to_s : exception.message.to_s
          msg = "health_check failed: #{msg}"
          if response_type == 'xml'
            content_type = 'text/xml'
            msg = { healthy: healthy, message: msg }.to_xml
          elsif response_type == 'json'
            content_type = 'application/json'
            msg = { healthy: healthy, message: msg }.to_json
          elsif response_type == 'plain'
            content_type = 'text/plain'
          end
          total_time = (Process.clock_gettime(Benchmark::BENCHMARK_CLOCK) - start_time) * 1000 #ms
          Rails.logger.info "Completed 500 Failure in #{total_time}ms"
          [ 500, { 'Content-Type' => content_type }, [msg] ]
        end
      else
        @app.call(env)
      end
    end
  end
end
