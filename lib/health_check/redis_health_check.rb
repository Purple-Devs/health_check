module HealthCheck
  class RedisHealthCheck
    extend BaseHealthCheck

    def self.check
      if (defined?(::Redis)).nil?
        raise "Wrong configuration. Missing 'redis' gem"
      end
      '' if ::Redis.new.ping
    rescue Exception => e
      create_error 'redis', e.message
    end
  end
end
