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

                basename = ::File.basename(filename)

                ::File.join("pool", basename[0], basename)
              end
            end
          end
        end
      end
    end
  end
end
