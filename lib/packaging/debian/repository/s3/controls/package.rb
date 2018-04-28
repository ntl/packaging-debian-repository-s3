module Packaging
  module Debian
    module Repository
      module S3
        module Controls
          Package = Packaging::Debian::Schemas::Controls::Package

          module Package
            def self.filename
              "#{package}-#{version}.deb"
            end

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
end
