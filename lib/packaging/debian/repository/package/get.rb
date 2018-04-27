module Packaging
  module Debian
    module Repository
      module Package
        class Get
          include Log::Dependency

          configure :get_package

          setting :suite
          setting :component
          setting :architecture

          dependency :get_object, AWS::S3::Client::Object::Get

          def configure(settings: nil, namespace: nil)
            settings ||= Settings.build
            namespace = Array(namespace)

            settings.set(self, *namespace)

            AWS::S3::Client::Object::Get.configure(self)
          end

          def self.build(settings: nil, namespace: nil)
            instance = new
            instance.configure(settings: settings, namespace: namespace)
            instance
          end

          def self.call(filename, settings: nil, namespace: nil)
            instance = build(settings: settings, namespace: namespace)
            instance.(filename)
          end

          def call(filename)
            object_key = path(filename)

            logger.trace { "Getting package (Path: #{object_key.inspect})" }

            begin
              data_source = get_object.(object_key)
            rescue AWS::S3::Client::Object::Get::ObjectNotFound
              logger.warn { "Package file not found (Path: #{object_key.inspect})" }
              return nil
            end

            logger.info { "Get package done (Path: #{object_key.inspect})" }

            data_source
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

