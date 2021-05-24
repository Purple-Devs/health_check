# frozen_string_literal: true

module HealthCheck
  class RedisHealthCheck
    extend BaseHealthCheck

    class << self
      def check
        raise "Wrong configuration. Missing 'redis' gem" unless defined?(::Redis)

        client.ping == 'PONG' ? '' : "Redis.ping returned #{res.inspect} instead of PONG"
      rescue Exception => err
        create_error 'redis', err.message
      ensure
        client.disconnect
      end

      def client
        Redis.new(url: HealthCheck.redis_url)
      end
    end
  end
end
