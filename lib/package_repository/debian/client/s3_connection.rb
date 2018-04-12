module PackageRepository
  module Debian
    module Client
      class S3Connection
        setting :access_key_id
        setting :secret_access_key
        setting :region
        setting :bucket

        def configure
          Settings.set(self)
        end

        def self.build
          instance = new
          instance.configure
          instance
        end

        def self.instance
          @instance ||= build
        end

        def self.configure_bucket(receiver, attr_name: nil)
          attr_name ||= :s3_bucket

          s3_bucket = instance.s3_bucket

          receiver.public_send("#{attr_name}=", s3_bucket)

          s3_bucket
        end

        def s3_bucket
          @s3_bucket ||= ::Aws::S3::Bucket.new(
            :name => self.bucket,
            :client => self.connect
          )
        end

        def connect
          return s3_client if connected?

          begin
            result = s3_client.list_buckets
          rescue Aws::S3::Errors::InvalidAccessKeyId, Aws::S3::Errors::SignatureDoesNotMatch => error
            raise Unauthorized, error.message
          end

          bucket_names = result.buckets.map(&:name)

          unless bucket_names.include?(bucket)
            raise BucketNotFound, "Bucket not found (Bucket: #{bucket.inspect})"
          end

          s3_client
        end

        def connected?
          !@s3_client.nil?
        end

        def s3_client
          @s3_client ||= ::Aws::S3::Client.new(
            :access_key_id => access_key_id,
            :secret_access_key => secret_access_key,
            :region => region
          )
        end

        BucketNotFound = Class.new(StandardError)
        Unauthorized = Class.new(StandardError)
      end
    end
  end
end
