module Packaging
  module Debian
    module Repository
      module Controls
        Package = Packaging::Debian::Package::Controls::Package

        module Package
          module Path
            def self.example(filename=nil)
              filename ||= Package.filename

              "pool/#{filename[0]}/#{filename}"
            end
          end
        end
      end
    end
  end
end
