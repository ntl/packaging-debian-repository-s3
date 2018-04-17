module PackageRepository
  module Debian
    module Client
      module Controls
        module Architecture
          def self.example
            'i386'
          end

          def self.alternate
            'sparc'
          end
        end
      end
    end
  end
end
