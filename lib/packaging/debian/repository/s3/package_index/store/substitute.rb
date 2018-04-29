module Packaging
  module Debian
    module Repository
      module S3
        class PackageIndex
          class Store
            module Substitute
              def self.build
                Store.new
              end

              class Store
                attr_accessor :get_package_index
                attr_accessor :get_component
                attr_accessor :get_architecture

                attr_accessor :put_package_index
                attr_accessor :put_component
                attr_accessor :put_architecture

                def get(component: nil, architecture: nil)
                  return nil unless component == get_component

                  return nil unless architecture == get_architecture

                  get_package_index
                end

                def fetch(component: nil, architecture: nil)
                  get(component: component, architecture: architecture) or
                    PackageIndex.new
                end

                def put(package_index, component: nil, architecture: nil)
                  self.put_package_index = package_index
                  self.put_component = component
                  self.put_architecture = architecture
                end

                def put?(package_index=nil, &block)
                  return false if put_package_index.nil?

                  if package_index.nil?
                    if block.nil?
                      true
                    else
                      block.(
                        put_package_index,
                        put_component,
                        put_architecture
                      )
                    end
                  else
                    put_package_index == package_index
                  end
                end

                def add(package_index, component: nil, architecture: nil)
                  self.get_package_index = package_index
                  self.get_component = component
                  self.get_architecture = architecture
                end
              end
            end
          end
        end
      end
    end
  end
end
