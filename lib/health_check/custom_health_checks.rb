module HealthCheck
  class CustomHealthChecks

    def self.check_sidekiq_redis
      Sidekiq.redis { |r| "" if r.ping == "PONG" }
    rescue => e
       create_error 'sidekiq-redis', e.message
    end

    def self.check_redis
      "" if Redis.new.ping
    rescue Exception => e
       create_error 'redis', e.message
    end

    def self.check_s3
      s3Client = s3_client
      return create_error 's3', "Could not connect to aws" if s3Client.nil?
      HealthCheck.buckets.each do |bucket|
        s3Client.put_object(bucket: bucket,key: 'FOO', body: 'BAR')
        if !s3Client.get_object(bucket: bucket,key: 'FOO').successful?
          return create_error 's3', "Could not fetch object from s3 bucket: #{bucket}"
        end
      end
      ""
    rescue Exception => e
      create_error 's3', e.message
    end

    def self.s3_client
      return unless defined?(Rails)

      aws_configuration = {
            region: Rails.application.secrets.aws_default_region,
            credentials: Aws::Credentials.new(
              Rails.application.secrets.aws_access_key_id,
              Rails.application.secrets.aws_secret_access_key
            ),
            force_path_style: true,
      }

      Aws::S3::Client.new aws_configuration
    end

    def self.create_error check_type, error_message
      "[#{check_type} - #{error_message}] "
    end

  end
end
