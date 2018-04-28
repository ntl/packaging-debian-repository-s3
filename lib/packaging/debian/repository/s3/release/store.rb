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

            def get
              logger.trace { "Getting release (Distribution: #{distribution}, Object Key: #{object_key.inspect})" }

              begin
                data_source = get_object.(object_key)
              rescue AWS::S3::Client::Object::Get::ObjectNotFound
                logger.warn { "Release file not found (Distribution: #{distribution}, Object Key: #{object_key.inspect})" }
                return nil
              end

              text = String.new

              text << data_source.read until data_source.eof?

              release = ::Transform::Read.(text, :rfc822_signed, Release)

              logger.info { "Get release done (Distribution: #{distribution}, Object Key: #{object_key.inspect})" }

              release
            end

            def fetch
              release = get

              if release.nil?
                release = Release.new
              end

              release
            end

            def put(release)
              logger.trace { "Putting release (Distribution: #{distribution}, Object Key: #{object_key.inspect})" }

              signed_text = ::Transform::Write.(release, :rfc822_signed)

              data_stream = StringIO.new(signed_text)

              result = put_object.(object_key, data_stream, acl: 'public-read')

              logger.info { "Put release done (Distribution: #{distribution}, Object Key: #{object_key.inspect})" }

              result
            end

            def object_key
              ::File.join('dists', distribution, 'InRelease')
            end
          end
        end
      end
    end
  end
end
