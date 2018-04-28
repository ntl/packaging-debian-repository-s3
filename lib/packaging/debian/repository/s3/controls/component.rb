module Packaging
  module Debian
    module Repository
      module S3
        module Controls
          module Component
            def self.example
              Defaults.component
            end

            Alternate = Schemas::Controls::Component::Alternate
          end
        end
      end
    end
  end
end
