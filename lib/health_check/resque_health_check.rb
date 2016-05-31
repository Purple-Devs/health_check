module HealthCheck
   class ResqueHealthCheck
     extend BaseHealthCheck

     def self.check
       '' if Resque.redis.ping == 'PONG'
     rescue Exception => e
       create_error 'resque-redis', e.message
     end
   end
end
