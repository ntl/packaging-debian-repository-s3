module Packaging
  module Debian
    module Repository
      module S3
        class PackageIndex
          class Store
            include Log::Dependency

            configure :store

            dependency :get_object, AWS::S3::Client::Object::Get
            dependency :put_object, AWS::S3::Client::Object::Put

            def configure(component: nil, architecture: nil)
              self.component = component unless component.nil?
              self.architecture = architecture unless architecture.nil?

              AWS::S3::Client::Object::Get.configure(self)
              AWS::S3::Client::Object::Put.configure(self)
            end

            attr_writer :architecture
            def architecture
              @architecture ||= Defaults.architecture
            end

            attr_writer :component
            def component
              @component ||= Defaults.component
            end

            initializer :distribution

            def self.build(distribution_or_path)
              if match_data = parse_path(distribution_or_path)
                distribution, component, architecture = match_data
              else
                distribution = distribution_or_path
              end

              instance = new(distribution)
              instance.configure(component: component, architecture: architecture)
              instance
            end

            def self.parse_path(path)
              match_data = path_pattern.match(path)

              return nil if match_data.nil?

              _, distribution, component, architecture = match_data.to_a

              return distribution, component, architecture
            end

            def self.path_pattern
              part = %r{[[:graph:]]+?}

              %r{\Adists/(?<distribution>#{part})/(?<component>#{part})/binary-(?<architecture>#{part})/Packages.gz}
            end

            def get(distribution: nil, component: nil, architecture: nil)
              object_key = object_key(distribution: distribution, component: component, architecture: architecture)

              logger.trace { "Getting package index (Object Key: #{object_key.inspect})" }

              data_stream = get_object.(object_key)

              if data_stream.nil?
                logger.warn { "Package index file not found (Object Key: #{object_key.inspect})" }
                return nil
              end

              compressed_text = String.new

              compressed_text << data_stream.read until data_stream.eof?

              package_index = ::Transform::Read.(
                compressed_text,
                :rfc822_compressed,
                PackageIndex
              )

              logger.info { "Get package index done (Object Key: #{object_key.inspect})" }

              package_index
            end

            def fetch(distribution: nil, component: nil, architecture: nil)
              package_index = get(
                distribution: distribution,
                component: component,
                architecture: architecture
              )

              if package_index.nil?
                package_index = PackageIndex.new
              end

              package_index
            end

            def put(package_index, distribution: nil, component: nil, architecture: nil)
              object_key = object_key(distribution: distribution, component: component, architecture: architecture)

              logger.trace { "Putting package index (Object Key: #{object_key.inspect})" }

              compressed_text = ::Transform::Write.(package_index, :rfc822_compressed)

              put_object.(object_key, compressed_text, acl: 'public-read')

              logger.info { "Put package index done (Object Key: #{object_key.inspect})" }

              return object_key, compressed_text
            end

            def object_key(distribution: nil, component: nil, architecture: nil)
              distribution ||= self.distribution
              component ||= self.component
              architecture ||= self.architecture

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
end
