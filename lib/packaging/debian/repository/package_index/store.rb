module Packaging
  module Debian
    module Repository
      class PackageIndex
        class Store
          include Log::Dependency

          configure :store

          attr_writer :architecture
          def architecture
            @architecture ||= Defaults.architecture
          end

          attr_writer :component
          def component
            @component ||= Defaults.component
          end

          initializer :distribution

          dependency :get_object, AWS::S3::Client::Object::Get
          dependency :put_object, AWS::S3::Client::Object::Put

          def configure(component: nil, architecture: nil)
            self.component = component unless component.nil?
            self.architecture = architecture unless architecture.nil?

            AWS::S3::Client::Object::Get.configure(self)
            AWS::S3::Client::Object::Put.configure(self)
          end

          def self.build(distribution_or_path)
            if match_data = path_pattern.match(distribution_or_path)
              distribution = match_data[:distribution]
              component = match_data[:component]
              architecture = match_data[:architecture]
            else
              distribution = distribution_or_path
            end

            instance = new(distribution)
            instance.configure(component: component, architecture: architecture)
            instance
          end

          def self.path_pattern
            part = %r{[[:graph:]]+?}

            %r{\Adists/(?<distribution>#{part})/(?<component>#{part})/binary-(?<architecture>#{part})/Packages.gz}
          end

          def get(architecture: nil)
            architecture ||= self.architecture

            object_key = object_key(architecture)

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

          def fetch(architecture: nil)
            package_index = get(architecture: architecture)

            if package_index.nil?
              package_index = PackageIndex.new
            end

            package_index
          end

          def put(package_index, architecture: nil)
            architecture ||= self.architecture

            object_key = object_key(architecture)

            logger.trace { "Putting package index (Object Key: #{object_key.inspect})" }

            compressed_text = ::Transform::Write.(package_index, :rfc822_compressed)

            result = put_object.(object_key, compressed_text, acl: 'public-read')

            logger.info { "Put package index done (Object Key: #{object_key.inspect})" }

            result
          end

          def object_key(architecture)
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
