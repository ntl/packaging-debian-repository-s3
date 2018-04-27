module Packaging
  module Debian
    module Repository
      class Release
        class Put
          include Log::Dependency

          configure :put_release

          setting :suite
          setting :gpg_password

          dependency :put_object, AWS::S3::Client::Object::Put

          def configure(settings: nil, namespace: nil)
            settings ||= Settings.build
            namespace = Array(namespace)

            settings.configure(self, *namespace)

            AWS::S3::Client::Object::Put.configure(self)
          end

          def self.build
            instance = new
            instance.configure
            instance
          end

          def self.call(release)
            instance = build
            instance.(release)
          end

          def call(release)
            logger.trace { "Putting release (Path: #{path.inspect})" }

            signed_text = ::Transform::Write.(release, :rfc822_signed)

            data_stream = StringIO.new(signed_text)

            object_key = path

            put_object.(object_key, data_stream, acl: 'public-read')

            logger.trace { "Put release done (Path: #{path.inspect})" }
          end

          def path
            ::File.join('dists', suite.to_s, 'InRelease')
          end
        end
      end
    end
  end
end
