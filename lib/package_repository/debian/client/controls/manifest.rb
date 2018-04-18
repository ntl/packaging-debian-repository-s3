module PackageRepository
  module Debian
    module Client
      module Controls
        module Manifest
          def self.example(suite: nil, component: nil, architecture: nil, packages: nil)
            suite ||= Suite.example
            component ||= Component.example
            architecture ||= Architecture.example
            packages ||= Packages.example

            Client::Manifest.build(
              :suite => suite,
              :component => component,
              :architecutre => architecture,
              :packages => packages
            )
          end

          module Packages
            def self.example
              [
                Client::Manifest::Package.build({
                  :filename => 'some-package-1.1.1-11.deb',
                  :size => 11,
                  :md5 => 'aaaaaa',
                  :package => 'some-package',
                  :version => '1.1.1-11',
                  :depends => 'some-dependency, other-dependency'
                }),

                Client::Manifest::Package.build({
                  :filename => 'other-package-2.2.2-22.deb',
                  :size => 22,
                  :md5 => 'bbbbbb',
                  :package => 'other-package',
                  :version => '2.2.2-22',
                  :depends => 'some-dependency, other-dependency'
                })
              ]
            end
          end

          module Text
            def self.example
              text = raw

              output_text = String.new

              output_io = StringIO.new(output_text)

              gzip_writer = Zlib::GzipWriter.new(output_io)
              gzip_writer.write(text)
              gzip_writer.close

              output_text
            end

            def self.raw
              <<~TEXT
              Filename: some-package-1.1.1-11.deb
              Size: 11
              Md5: aaaaaa
              Package: some-package
              Version: 1.1.1-11
              Depends: some-dependency, other-dependency

              Filename: other-package-2.2.2-22.deb
              Size: 22
              Md5: bbbbbb
              Package: other-package
              Version: 2.2.2-22
              Depends: some-dependency, other-dependency
              TEXT
            end
          end

          module Path
            def self.example(suite: nil, component: nil, architecture: nil)
              Controls::Path.example(
                filename,
                suite: suite,
                component: component,
                architecture: architecture
              )
            end

            def self.filename
              'Packages.gz'
            end
          end
        end
      end
    end
  end
end
