# frozen_string_literal: true

module HealthCheck
  class RedisHealthCheck
    extend BaseHealthCheck

    class << self
      def check
        client.call('PING')  == 'PONG' ? '' : "ping returned #{res.inspect} instead of PONG"
      rescue Exception => err
        create_error 'redis', err.message
      ensure
        client.close if client.connected?
      end

      def client
        @client ||= begin
          if defined?(::Redis)
            Redis.new(redis_config)
          elsif defined?(::RedisClient)
            RedisClient.new(redis_config)
          else
            raise "Wrong configuration. Missing 'redis' or 'redis-client' gem"
          end
        end
      end

      def redis_config
        {
          url: HealthCheck.redis_url,
          password: HealthCheck.redis_password
        }.reject { |k, v| v.nil? }
      end
    end
  end
end
