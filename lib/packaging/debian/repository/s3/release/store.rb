module Packaging
  module Debian
    module Repository
      module S3
        class Release
          class Store
            include Log::Dependency

            configure :store

            initializer :distribution

            dependency :get_object, AWS::S3::Client::Object::Get
            dependency :put_object, AWS::S3::Client::Object::Put

            def configure
              AWS::S3::Client::Object::Get.configure(self)
              AWS::S3::Client::Object::Put.configure(self)
            end

            def self.build(distribution)
              instance = new(distribution)
              instance.configure
              instance
            end

            def self.call(distribution)
              instance = build(distribution)
              instance.()
            end

            def get(distribution: nil)
              object_key = object_key(distribution)

              logger.trace { "Getting release (Object Key: #{object_key.inspect})" }

              data_stream = get_object.(object_key)

              if data_stream.nil?
                logger.warn { "Release file not found (Object Key: #{object_key.inspect})" }
                return nil
              end

              text = String.new

              text << data_stream.read until data_stream.eof?

              release = ::Transform::Read.(text, :rfc822_signed, Release)

              logger.info { "Get release done (Object Key: #{object_key.inspect})" }

              release
            end

            def fetch
              release = get

              if release.nil?
                release = Release.new
              end

              release
            end

            def put(release, distribution: nil)
              object_key = object_key(distribution)

              logger.trace { "Putting release (Object Key: #{object_key.inspect})" }

              signed_text = ::Transform::Write.(release, :rfc822_signed)

              data_stream = StringIO.new(signed_text)

              put_object.(object_key, data_stream, acl: 'public-read')

              logger.info { "Put release done (Object Key: #{object_key.inspect})" }

              return object_key, signed_text
            end

            def object_key(distribution=nil)
              distribution ||= self.distribution

              ::File.join('dists', distribution, 'InRelease')
            end
          end
        end
      end
    end
  end
end
