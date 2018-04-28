module Packaging
  module Debian
    module Repository
      class PackageIndex
        module ObjectKey
          def object_key(component, architecture)
            ::File.join(
              'dists',
              distribution,
              component,
              "binary-#{architecture}",
              'Packages.gz'
            )
          end
        end
      end
    end
  end
end
