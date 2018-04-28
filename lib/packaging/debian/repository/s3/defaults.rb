module Packaging
  module Debian
    module Repository
      module Defaults
        def self.architecture
          'amd64'
        end

        def self.component
          'main'
        end
      end
    end
  end
end
