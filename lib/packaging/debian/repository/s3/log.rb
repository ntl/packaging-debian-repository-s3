module Packaging
  module Debian
    module Repository
      module S3
        class Log < ::Log
          def tag!(tags)
            tags << :packaging_debian_repository_s3
            tags << :packaging
            tags << :libraries
            tags << :verbose
          end
        end
      end
    end
  end
end
