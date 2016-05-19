module HealthCheck
  class CustomHealthChecks

    def self.check_sidekiq_redis
      Sidekiq.redis { |r| "" if r.ping == "PONG" }
    rescue Exception => e
       create_error 'sidekiq-redis', e.message
    end

    def self.check_redis
      "" if Redis.new.ping
    rescue Exception => e
       create_error 'redis', e.message
    end

    def self.check_s3
      return create_error 's3', "Could not connect to aws" if aws_s3_client.nil?

      health_check_filename = 'health-check'

      HealthCheck.buckets.each do |bucket|
        aws_s3_client.put_object(bucket: bucket, key: health_check_filename, body: 'BAR')
        unless aws_s3_client.get_object(bucket: bucket, key: health_check_filename).successful?
          return create_error 's3', "Could not get object from s3 bucket: #{bucket}"
        end

        aws_s3_client.delete_object(bucket: bucket, key: health_check_filename)
        if aws_s3_client.get_object(bucket: bucket, key: health_check_filename).successful?
          return create_error 's3', "Test object was not deleted from s3 bucket: #{bucket}"
        end
      end
      ""
    rescue Exception => e
      create_error 's3', e.message
    end

    def self.configure_client
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

    def self.aws_s3_client
      @aws_s3_client ||= configure_client
    end

    def self.create_error check_type, error_message
      "[#{check_type} - #{error_message}] "
    end

  end
end
