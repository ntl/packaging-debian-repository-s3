module Packaging
  module Debian
    module Repository
      class PackageIndex
        class Store
          module Substitute
            def self.build
              Store.new
            end

            class Store
              attr_accessor :get_package_index
              attr_accessor :get_architecture

              attr_accessor :put_package_index
              attr_accessor :put_architecture

              def get(architecture: nil)
                return nil unless architecture == get_architecture

                get_package_index
              end

              def fetch(architecture: nil)
                get(architecture: architecture) || PackageIndex.new
              end

              def put(package_index, architecture: nil)
                self.put_package_index = package_index
                self.put_architecture = architecture
              end

              def put?(package_index=nil, &block)
                return false if put_package_index.nil?

                if package_index.nil?
                  if block.nil?
                    true
                  else
                    block.(put_package_index, put_architecture)
                  end
                else
                  put_package_index == package_index
                end
              end

              def add(package_index, architecture=nil)
                self.get_package_index = package_index
                self.get_architecture = architecture
              end
            end
          end
        end
      end
    end
  end
end
