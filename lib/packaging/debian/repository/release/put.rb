module Packaging
  module Debian
    module Repository
      class Release
        class Put
          include Log::Dependency

          configure :put_release

          setting :distribution
          setting :gpg_password

          dependency :put_object, AWS::S3::Client::Object::Put

          def configure(settings: nil, namespace: nil)
            settings ||= Settings.build
            namespace = Array(namespace)

            settings.configure(self, *namespace)

            AWS::S3::Client::Object::Put.configure(self)
          end

          def self.build(settings: nil, namespace: nil)
            instance = new
            instance.configure(settings: settings, namespace: namespace)
            instance
          end

          def self.call(release, settings: nil, namespace: nil)
            instance = build(settings: settings, namespace: namespace)
            instance.(release)
          end

          def call(release)
            logger.trace { "Putting release (Path: #{path.inspect})" }

            signed_text = ::Transform::Write.(release, :rfc822_signed)

            data_stream = StringIO.new(signed_text)

            object_key = path

            put_object.(object_key, data_stream, acl: 'public-read')

            logger.info { "Put release done (Path: #{path.inspect})" }
          end

          def path
            ::File.join('dists', distribution.to_s, 'InRelease')
          end
        end
      end
    end
  end
end
