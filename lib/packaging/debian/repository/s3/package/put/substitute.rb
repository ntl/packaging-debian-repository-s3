module Packaging
  module Debian
    module Repository
      module Package
        class Put
          module Substitute
            def self.build
              Put.new
            end

            class Put < Put
              def put?(filename=nil, &block)
                if filename.nil?
                  block ||= proc { true }
                else
                  block ||= proc { |object_key| object_key == object_key(filename) }
                end

                put_object.put?(&block)
              end
            end
          end
        end
      end
    end
  end
end
