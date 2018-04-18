module PackageRepository
  module Debian
    module Client
      module Controls
        module Package
          module File
            def self.example(package: nil, version: nil, contents: nil, **attributes)
              package ||= Attributes.package
              version ||= Attributes.version
              contents ||= Contents.example

              tmp_dir = Dir.mktmpdir('package-control')

              stage_dir = ::File.join(tmp_dir, "#{package}-#{version}")

              debian_dir = ::File.join(stage_dir, 'DEBIAN')

              Dir.mkdir(stage_dir)
              Dir.mkdir(debian_dir)

              control_file = Control.text(
                package: package,
                version: version,
                **attributes
              )

              ::File.write(
                ::File.join(debian_dir, 'control'),
                control_file
              )

              contents.each do |file, data|
                path = ::File.join(stage_dir, file)

                ::File.write(path, data)
              end

              `dpkg-deb -v --build #{stage_dir}`

              ::File.join(tmp_dir, "#{package}-#{version}.deb")
            end

            def self.name(package: nil, version: nil)
              package ||= Attributes.package
              version ||= Attributes.version

              "#{package}-#{version}.deb"
            end

            module Alternate
              def self.example
                default_source = Package::Attributes::Alternate

                File.example(default_source: default_source)
              end

              def self.name
                package = Attributes::Alternate.package
                version = Attributes::Alternate.version

                File.name(package: package, version: version)
              end
            end
          end
        end
      end
    end
  end
end
