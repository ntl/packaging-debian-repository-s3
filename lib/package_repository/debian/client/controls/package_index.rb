module PackageRepository
  module Debian
    module Client
      module Controls
        PackageIndex = Packaging::Debian::Schemas::Controls::Repository::PackageIndex

        module PackageIndex
          module Path
            def self.example
              "dists/#{suite}/#{component}/#{architecture}/Packages.gz"
            end

            def self.suite
              Suite.example
            end

            def self.component
              Component.example
            end

            def self.architecture
              Architecture.example
            end
          end
        end
      end
    end
  end
end
