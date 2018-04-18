module PackageRepository
  module Debian
    module Client
      module Controls
        module Package
          module Control
            def self.text(default_source: nil, **attributes)
              package = Package.example(
                default_source: default_source,
                **attributes
              )

              <<~TEXT
              Package: #{package.package}
              Source: #{package.source}
              Version: #{package.version}
              Section: #{package.section}
              Priority: #{package.priority}
              Architecture: #{package.architecture}
              Essential: #{package.essential ? 'yes' : 'no'}
              Depends: #{package.depends}
              Pre-Depends: #{package.pre_depends}
              Recommends: #{package.recommends}
              Suggests: #{package.suggests}
              Enhances: #{package.enhances}
              Breaks: #{package.breaks}
              Conflicts: #{package.conflicts}
              Installed-Size: #{package.installed_size}
              Maintainer: #{package.maintainer}
              Description: #{package.description}
              Homepage: #{package.homepage}
              Built-Using: #{package.built_using}
              TEXT
            end

            module Alternate
              def self.text
                default_source = Package::Attributes::Alternate

                Control.text(default_source: default_source)
              end
            end
          end
        end
      end
    end
  end
end
