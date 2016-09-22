module HealthCheck
  class SidekiqHealthCheck
    extend BaseHealthCheck

    def self.check
      unless defined?(::Sidekiq)
        raise "Wrong configuration. Missing 'sidekiq' gem"
      end
      ::Sidekiq.redis do |r|
        res = r.ping
        res == 'PONG' ? '' : "Sidekiq.redis.ping returned #{res.inspect} instead of PONG"
      end
    rescue Exception => e
      create_error 'sidekiq-redis', e.message
    end
  end
end
