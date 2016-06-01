module HealthCheck
  class RedisHealthCheck
    extend BaseHealthCheck

    def self.check
      unless defined?(::Redis)
        raise "Wrong configuration. Missing 'redis' gem"
      end
      '' if ::Redis.new.ping
    rescue Exception => e
      create_error 'redis', e.message
    end
  end
end
