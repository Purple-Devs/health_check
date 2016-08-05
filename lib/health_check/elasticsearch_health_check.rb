module HealthCheck
  class ElasticsearchHealthCheck
    extend BaseHealthCheck

    def self.check
      unless defined?(::Elasticsearch)
        raise "Wrong configuration. Missing 'elasticsearch' gem"
      end
      res = ::Elasticsearch::Client.new.ping
      res == true ? '' : "Elasticsearch returned #{res.inspect} instead of true"
    rescue Exception => e
      create_error 'elasticsearch', e.message
    end
  end
end
