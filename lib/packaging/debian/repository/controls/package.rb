module Packaging
  module Debian
    module Repository
      module Controls
        Package = Packaging::Debian::Package::Controls::Package

        module Package
          module Path
            def self.example
              "dists/#{distribution}/#{component}/binary-#{architecture}/#{filename}"
            end

            def self.filename
              Package.filename
            end

            def self.distribution
              Distribution.example
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
