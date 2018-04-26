module Packaging
  module Debian
    module Repository
      module Controls
        module DebFile
          def self.example(package: nil, version: nil, contents: nil, control_file_text: nil)
            package ||= self.package
            version ||= self.version
            contents ||= Package::Contents.example
            control_file_text ||= Package::Text.example

            tmp_dir = Dir.mktmpdir('package-control')

            stage_dir = ::File.join(tmp_dir, "#{package}-#{version}")

            debian_dir = ::File.join(stage_dir, 'DEBIAN')

            Dir.mkdir(stage_dir)
            Dir.mkdir(debian_dir)

            ::File.write(
              ::File.join(debian_dir, 'control'),
              control_file_text
            )

            contents.each do |file, data|
              path = ::File.join(stage_dir, file)

              ::File.write(path, data)
            end

            `dpkg-deb -v --build #{stage_dir}`

            ::File.join(tmp_dir, "#{package}-#{version}.deb")
          end

          def self.name(package: nil, version: nil)
            package ||= self.package
            version ||= self.version

            "#{package}-#{version}.deb"
          end

          def self.package
            Package::Data.package
          end

          def self.version
            Package::Data.version
          end

          module Alternate
            def self.example
              control_file_text = Package::Alternate::Text.example
              contents = Package::Contents::Alternate.example

              File.example(
                package: package,
                version: version,
                contents: contents,
                control_file_text: control_file_text
              )
            end

            def self.name
              File.name(package: package, version: version)
            end

            def self.package
              Package::Alternate::Data.package
            end

            def self.version
              Package::Alternate::Data.version
            end
          end
        end
      end
    end
  end
end
