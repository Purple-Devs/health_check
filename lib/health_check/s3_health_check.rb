module HealthCheck
  class S3HealthCheck
    extend BaseHealthCheck

    class << self
      def check
        unless defined?(::Aws)
          raise "Wrong configuration. Missing 'aws-sdk' gem"
        end
        return create_error 's3', 'Could not connect to aws' if aws_s3_client.nil?
        HealthCheck.buckets.each do |bucket_name, permissions|
          if permissions.nil? # backward compatible
            permissions = [:R, :W, :D]
          end
          permissions.each do |permision|
            begin
            send(permision, bucket_name)
          rescue Exception => e
            raise "bucket:#{bucket_name}, permission:#{permision} - #{e.message}"
          end
          end
        end
        ''
      rescue Exception => e
        create_error 's3', e.message
      end

      private

      def configure_client
        return unless defined?(Rails)

        aws_configuration = {
          region: Rails.application.secrets.aws_default_region,
          credentials: ::Aws::Credentials.new(
            Rails.application.secrets.aws_access_key_id,
            Rails.application.secrets.aws_secret_access_key
          ),
          force_path_style: true
        }

        ::Aws::S3::Client.new aws_configuration
      end

      def aws_s3_client
        @aws_s3_client ||= configure_client
      end

      def R(bucket)
        aws_s3_client.list_objects(bucket: bucket)
      end

      def W(bucket)
        aws_s3_client.put_object(bucket: bucket,
                                 key: "healthcheck_#{Rails.application.class.parent_name}",
                                 body: Time.new.to_s)
      end

      def D(bucket)
        aws_s3_client.delete_object(bucket: bucket,
                                    key: "healthcheck_#{Rails.application.class.parent_name}")
      end
    end
  end
end
