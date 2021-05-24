module HealthCheck
  class RabbitMQHealthCheck
    extend BaseHealthCheck
    def self.check
      unless defined?(::Bunny)
        raise "Wrong configuration. Missing 'bunny' gem"
      end
      connection = Bunny.new(HealthCheck.rabbitmq_config)
      connection.start
      connection.close
      ''
    rescue Exception => e
      create_error 'rabbitmq', e.message
    end
  end
end
