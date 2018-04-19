module PackageRepository
  module Debian
    module Client
      module Controls
        module Suite
          def self.example
            'stable'
          end

          module Alternate
            def self.example
              'unstable'
            end
          end
        end
      end
    end
  end
end
