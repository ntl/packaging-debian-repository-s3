module Packaging
  module Debian
    module Repository
      module Package
        class Put
          include Log::Dependency

          configure :put_package

          setting :suite
          setting :component
          setting :architecture

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

          def self.call(package, settings: nil, namespace: nil)
            instance = build(settings: settings, namespace: namespace)
            instance.(package)
          end

          def call(package)
            filename = File.basename(package)

            object_key = path(filename)

            logger.trace { "Putting release (Path: #{object_key.inspect})" }

            File.open(package, 'r') do |data_stream|
              put_object.(object_key, data_stream, acl: 'public-read')
            end

            logger.trace { "Put release done (Path: #{object_key.inspect})" }
          end

          def path(filename)
            ::File.join(
              'dists',
              suite.to_s,
              component.to_s,
              "binary-#{architecture}",
              filename
            )
          end
        end
      end
    end
  end
end
