module PackageRepository
  module Debian
    module Client
      module Controls
        module Suite
          def self.example
            'stable'
          end

          def self.alternate
            'unstable'
          end
        end
      end
    end
  end
end
