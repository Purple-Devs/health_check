module HealthCheck
   class ResqueHealthCheck
     extend BaseHealthCheck

     def self.check
       unless defined?(::Resque)
         raise "Wrong configuration. Missing 'resque' gem"
       end
      res = ::Resque.redis.ping
      res == 'PONG' ? '' : "Resque.redis.ping returned #{res.inspect} instead of PONG"
     rescue Exception => e
       create_error 'resque-redis', e.message
     end
   end
end
