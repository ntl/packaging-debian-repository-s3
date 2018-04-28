module Packaging
  module Debian
    module Repository
      class PackageIndex
        class Put
          include Log::Dependency

          include ObjectKey

          configure :put_package_index

          attr_writer :architecture
          def architecture
            @architecture ||= Defaults.architecture
          end

          attr_writer :component
          def component
            @component ||= Defaults.component
          end

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

          def self.call(package_index, distribution, component: nil, architecture: nil)
            instance = build(distribution)
            instance.(package_index, component: nil, architecture: architecture)
          end

          def call(package_index, component: nil, architecture: nil)
            component ||= self.component
            architecture ||= self.architecture

            object_key = object_key(component, architecture)

            logger.trace { "Putting package index (Object Key: #{object_key.inspect})" }

            compressed_text = ::Transform::Write.(package_index, :rfc822_compressed)

            result = put_object.(object_key, compressed_text, acl: 'public-read')

            logger.info { "Put package index done (Object Key: #{object_key.inspect})" }

            result
          end
        end
      end
    end
  end
end
