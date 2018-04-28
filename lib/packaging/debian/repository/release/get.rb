module Packaging
  module Debian
    module Repository
      class Release
        class Get
          include Log::Dependency

          configure :get_release

          initializer :distribution

          dependency :get_object, AWS::S3::Client::Object::Get

          def configure
            AWS::S3::Client::Object::Get.configure(self)
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

          def call
            logger.trace { "Getting release (Distribution: #{distribution}, Path: #{path.inspect})" }

            begin
              data_source = get_object.(path)
            rescue AWS::S3::Client::Object::Get::ObjectNotFound
              logger.warn { "Release file not found (Distribution: #{distribution}, Path: #{path.inspect})" }
              return nil
            end

            text = String.new

            text << data_source.read until data_source.eof?

            release = ::Transform::Read.(text, :rfc822_signed, Release)

            logger.info { "Get release done (Distribution: #{distribution}, Path: #{path.inspect})" }

            release
          end

          def path
            ::File.join('dists', distribution, 'InRelease')
          end
        end
      end
    end
  end
end
