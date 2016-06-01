module HealthCheck
   class ResqueHealthCheck
     extend BaseHealthCheck

     def self.check
       if (defined?(::Resque)).nil?
         raise "Wrong configuration. Missing 'resque' gem"
       end
       '' if ::Resque.redis.ping == 'PONG'
     rescue Exception => e
       create_error 'resque-redis', e.message
     end
   end
end
