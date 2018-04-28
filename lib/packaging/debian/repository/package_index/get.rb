module Packaging
  module Debian
    module Repository
      class PackageIndex
        class Get
          include Log::Dependency

          configure :get_package_index

          setting :distribution
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

          def self.call(settings: nil, namespace: nil)
            instance = build(settings: settings, namespace: namespace)
            instance.()
          end

          def call
            logger.trace { "Getting package index (Path: #{path.inspect})" }

            begin
              data_source = get_object.(path)
            rescue AWS::S3::Client::Object::Get::ObjectNotFound
              logger.warn { "Package index file not found (Path: #{path.inspect})" }
              return nil
            end

            compressed_text = String.new

            compressed_text << data_source.read until data_source.eof?

            package_index = ::Transform::Read.(
              compressed_text,
              :rfc822_compressed,
              PackageIndex
            )

            logger.info { "Get package index done (Path: #{path.inspect})" }

            package_index
          end

          def path
            ::File.join(
              'dists',
              distribution.to_s,
              component.to_s,
              "binary-#{architecture}",
              'Packages.gz'
            )
          end
        end
      end
    end
  end
end
