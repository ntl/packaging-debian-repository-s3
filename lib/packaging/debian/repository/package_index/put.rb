module Packaging
  module Debian
    module Repository
      class PackageIndex
        class Put
          include Log::Dependency

          configure :put_package_index

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

          def self.call(package_index, distribution, component, architecture)
            instance = build(distribution)
            instance.(package_index, component, architecture)
          end

          def call(package_index, component, architecture)
            object_key = object_key(component, architecture)

            logger.trace { "Putting package index (Object Key: #{object_key.inspect})" }

            compressed_text = ::Transform::Write.(package_index, :rfc822_compressed)

            result = put_object.(object_key, compressed_text, acl: 'public-read')

            logger.info { "Put package index done (Object Key: #{object_key.inspect})" }

            result
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
