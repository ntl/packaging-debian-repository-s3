module PackageRepository
  module Debian
    module Client
      module Controls
        module Package
          module Attributes
            def self.list
              %i[
                package source version section priority architecture essential
                depends pre_depends recommends suggests enhances breaks
                conflicts installed_size maintainer description homepage
                built_using
              ]
            end

            def self.package
              'some-package'
            end

            def self.source
              "some-source-package (#{version})"
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

            def self.section
              'some-section'
            end

            def self.priority
              'optional'
            end

            def self.architecture
              Architecture.all
            end

            def self.essential
              true
            end

            def self.depends
              'some-dependency'
            end

            def self.pre_depends
              'some-pre-dependency'
            end

            def self.recommends
              'some-recommended-dependency'
            end

            def self.suggests
              'some-suggested-dependency'
            end

            def self.enhances
              'some-enhanced-dependency'
            end

            def self.breaks
              'some-broken-dependency'
            end

            def self.conflicts
              'some-conflicted-dependency'
            end

            def self.installed_size
              111
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

            def self.built_using
              'gcc-1.11'
            end

            module Alternate
              def self.package
                'other-package'
              end

              def self.source
                "other-source-package (#{version})"
              end

              def self.version
                "#{upstream_version}-#{revision}"
              end

              def self.upstream_version
                '2.2.2'
              end

              def self.revision
                '22'
              end

              def self.section
                'other-section'
              end

              def self.priority
                'extra'
              end

              def self.architecture
                Architecture::Alternate.example
              end

              def self.essential
                true
              end

              def self.depends
                'other-dependency'
              end

              def self.pre_depends
                'other-pre-dependency'
              end

              def self.recommends
                'other-recommended-dependency'
              end

              def self.suggests
                'other-suggested-dependency'
              end

              def self.enhances
                'other-enhanced-dependency'
              end

              def self.breaks
                'other-broken-dependency'
              end

              def self.conflicts
                'other-conflicted-dependency'
              end

              def self.installed_size
                222
              end

              def self.maintainer
                'Other Maintainer'
              end

              def self.description
                'Other package'
              end

              def self.homepage
                'http://example.com/other'
              end

              def self.built_using
                'gcc-2.22'
              end
            end
          end
        end
      end
    end
  end
end
