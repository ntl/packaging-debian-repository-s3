module Packaging
  module Debian
    module Repository
      module Package
        class Get
          module Substitute
            def self.build
              Get.new
            end

            class Get < Get
              def add(filename, data)
                object_key = object_key(filename)

                data_stream = StringIO.new(data)

                get_object.add(object_key, data_stream)
              end
            end
          end
        end
      end
    end
  end
end
