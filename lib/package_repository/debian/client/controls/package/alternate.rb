module PackageRepository
  module Debian
    module Client
      module Controls
        module Package
          module Alternate
            def self.example(**attributes)
              Package.example(default_source: Attributes, **attributes)
            end

            def self.data(**attributes)
              package = self.example(**attributes)
              package.to_h
            end

            Attributes = Package::Attributes::Alternate

            Control = Package::Control::Alternate

            Contents = Package::Contents::Alternate

            File = Package::File::Alternate
          end
        end
      end
    end
  end
end
