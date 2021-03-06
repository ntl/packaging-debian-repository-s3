module Packaging
  module Debian
    module Repository
      module S3
        module Defaults
          def self.architecture
            'amd64'
          end

          def self.component
            'main'
          end

          def self.acl
            'private'
          end
        end
      end
    end
  end
end
