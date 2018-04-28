module Packaging
  module Debian
    module Repository
      class PackageIndex
        class Get
          include Log::Dependency

          configure :get_package_index

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

          def self.call(distribution, component, architecture)
            instance = build(distribution)
            instance.(component, architecture)
          end

          def call(component, architecture)
            object_key = object_key(component, architecture)

            logger.trace { "Getting package index (Object Key: #{object_key.inspect})" }

            begin
              data_source = get_object.(object_key)
            rescue AWS::S3::Client::Object::Get::ObjectNotFound
              logger.warn { "Package index file not found (Object Key: #{object_key.inspect})" }
              return nil
            end

            compressed_text = String.new

            compressed_text << data_source.read until data_source.eof?

            package_index = ::Transform::Read.(
              compressed_text,
              :rfc822_compressed,
              PackageIndex
            )

            logger.info { "Get package index done (Object Key: #{object_key.inspect})" }

            package_index
          end

          def object_key(component, architecture)
            ::File.join(
              'dists',
              distribution,
              component,
              "binary-#{architecture}",
              'Packages.gz'
            )
          end
        end
      end
    end
  end
end
