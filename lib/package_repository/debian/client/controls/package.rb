module PackageRepository
  module Debian
    module Client
      module Controls
        module Package
          def self.example(package: nil, version: nil, contents: nil, **metadata_attributes)
            package ||= Metadata.package
            version ||= Metadata.version
            contents ||= Contents.example

            tmp_dir = Dir.mktmpdir('package-control')

            stage_dir = File.join(tmp_dir, "#{package}-#{version}")

            debian_dir = File.join(stage_dir, 'DEBIAN')

            Dir.mkdir(stage_dir)
            Dir.mkdir(debian_dir)

            control_file = ControlFile.text(
              package: package,
              version: version,
              **metadata_attributes
            )

            File.write(
              File.join(debian_dir, 'control'),
              control_file
            )

            contents.each do |file, data|
              path = File.join(stage_dir, file)

              File.write(path, data)
            end

            `dpkg-deb -v --build #{stage_dir}`

            File.join(tmp_dir, "#{package}-#{version}.deb")
          end

          module Contents
            def self.example
              {
                'contents.txt' => 'Example debian package'
              }
            end
          end

          module Metadata
            def self.package
              'some-package'
            end

            def self.version
              "#{upstream_version}-#{revision}"
            end

            def self.upstream_version
              '1.1.1'
            end

            def self.revision
              '11'
            end

            def self.maintainer
              'Some Maintainer'
            end

            def self.description
              'Some package'
            end

            def self.homepage
              'http://example.com'
            end

            def self.depends
              'some-dependency, other-dependency'
            end

            def self.priority
              'optional'
            end

            def self.architecture
              Architecture.all
            end

            def self.filepackage
              'some-package-1.1.1-11.deb'
            end

            module GetField
              def self.call(deb_file, field_package)
                field_package = field_package.to_s

                field_package[0] = field_package[0].upcase

                line = `dpkg-deb -f #{deb_file} | grep #{field_package}`.chomp

                _, value = line.split(/[[:blank:]]+/, 2)

                value
              end
            end
          end

          module ControlFile
            def self.text(package: nil, version: nil, maintainer: nil, description: nil, homepage: nil, depends: nil, priority: nil, architecture: nil)
              package ||= Metadata.package
              version ||= Metadata.version
              maintainer ||= Metadata.maintainer
              description ||= Metadata.description
              homepage ||= Metadata.homepage
              depends ||= Metadata.depends
              priority ||= Metadata.priority
              architecture ||= Metadata.architecture

              <<~TEXT
              Package: #{package}
              Version: #{version}
              Maintainer: #{maintainer}
              Description: #{description}
              Homepage: #{homepage}
              Depends: #{depends}
              Priority: #{priority}
              Architecture: all
              TEXT
            end
          end

          module Extract
            def self.call(deb_file)
              dir = Dir.mktmpdir

              `dpkg-deb -x #{deb_file} #{dir}`

              dir
            end
          end
        end
      end
    end
  end
end
