module Packaging
  module Debian
    module Repository
      class Release
        class Put
          include Log::Dependency

          configure :put_release

          initializer :distribution

          dependency :put_object, AWS::S3::Client::Object::Put

          def configure
            AWS::S3::Client::Object::Put.configure(self)
          end

          def self.build(distribution)
            instance = new(distribution)
            instance.configure
            instance
          end

          def self.call(release, distribution)
            instance = build(distribution)
            instance.(release)
          end

          def call(release)
            logger.trace { "Putting release (Distribution: #{distribution}, Path: #{path.inspect})" }

            signed_text = ::Transform::Write.(release, :rfc822_signed)

            data_stream = StringIO.new(signed_text)

            object_key = path

            result = put_object.(object_key, data_stream, acl: 'public-read')

            logger.info { "Put release done (Distribution: #{distribution}, Path: #{path.inspect})" }

            result
          end

          def path
            ::File.join('dists', distribution, 'InRelease')
          end
        end
      end
    end
  end
end
