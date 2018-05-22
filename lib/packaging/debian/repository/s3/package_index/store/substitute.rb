module Packaging
  module Debian
    module Repository
      module S3
        class PackageIndex
          class Store
            module Substitute
              def self.build
                Store.build
              end

              class Store < Store
                def self.build
                  instance = new
                  instance.distribution = distribution
                  instance
                end

                def self.distribution
                  'null'
                end

                def put?(package_index=nil, &block)
                  if package_index.nil?
                    block ||= proc { true }
                  else
                    block ||= proc { |put_package_index| package_index == put_package_index }
                  end

                  put_object.put? do |object_key, telemetry_data|
                    put_text = telemetry_data.data_source

                    put_package_index = ::Transform::Read.(
                      put_text,
                      :rfc822_compressed,
                      PackageIndex
                    )

                    block.(put_package_index, object_key)
                  end
                end

                def add(package_index, distribution: nil, component: nil, architecture: nil)
                  object_key = object_key(distribution: distribution, component: component, architecture: architecture)

                  compressed_text = ::Transform::Write.(
                    package_index,
                    :rfc822_compressed
                  )

                  data_stream = StringIO.new(compressed_text)

                  get_object.add(object_key, data_stream)
                end
              end
            end
          end
        end
      end
    end
  end
end
