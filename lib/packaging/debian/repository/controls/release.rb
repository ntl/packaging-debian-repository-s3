module Packaging
  module Debian
    module Repository
      module Controls
        Release = Packaging::Debian::Schemas::Controls::Release

        module Release
          module Path
            def self.example
              "dists/#{distribution}/InRelease"
            end

            def self.distribution
              Distribution.example
            end
          end
        end
      end
    end
  end
end
