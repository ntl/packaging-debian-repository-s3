module Packaging
  module Debian
    module Repository
      module S3
        module Controls
          module Architecture
            def self.example
              Defaults.architecture
            end

            Alternate = Schemas::Controls::Architecture::Alternate
          end
        end
      end
    end
  end
end