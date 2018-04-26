module PackageRepository
  module Debian
    module Client
      module Controls
        module Distribution
          def self.example
            Suite.example
          end

          def self.sample
            [
              Suite.example,
              Codename.example
            ].sample
          end
        end
      end
    end
  end
end
