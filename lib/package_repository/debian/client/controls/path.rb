module PackageRepository
  module Debian
    module Client
      module Controls
        module Path
          def self.example(filename=nil, prefix: nil, suite: nil, component: nil, architecture: nil)
            filename ||= self.filename

            prefix ||= Prefix.example(suite: suite, component: component, architecture: architecture)

            File.join(prefix, filename)
          end

          module Prefix
            def self.example(suite: nil, component: nil, architecture: nil)
              suite ||= Suite.example
              component ||= Component.example
              architecture ||= Architecture.example

              File.join('dists', suite, component, architecture)
            end
          end
        end
      end
    end
  end
end
