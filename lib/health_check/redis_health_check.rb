module HealthCheck
  class RedisHealthCheck
    extend BaseHealthCheck

    def self.check
      '' if Redis.new.ping
    rescue Exception => e
      create_error 'redis', e.message
    end
  end
end
