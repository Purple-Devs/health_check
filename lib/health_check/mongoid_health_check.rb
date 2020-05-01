module HealthCheck
  class MongoidHealthCheck
    extend BaseHealthCheck

    def self.check
      unless defined?(::Mongoid)
        raise "Wrong configuration. Missing 'mongoid' gem"
      end

      server_selection_timeout = Mongoid.clients['default']['options']['server_selection_timeout']
      Mongoid.clients['default']['options']['server_selection_timeout'] = HealthCheck.mongoid_server_selection_timeout
      Mongoid.default_client.command(buildInfo: 1).first[:version]
      ''
    rescue Exception => e
      create_error 'mongoid', e.message
    ensure
      Mongoid.disconnect_clients
      Mongoid.clients['default']['options']['server_selection_timeout'] = server_selection_timeout ||= 30
    end
  end
end
