module HealthCheck
  class SidekiqHealthCheck
    extend BaseHealthCheck

    def self.check
      Sidekiq.redis { |r| '' if r.ping == 'PONG' }
    rescue Exception => e
      create_error 'sidekiq-redis', e.message
    end
  end
end
