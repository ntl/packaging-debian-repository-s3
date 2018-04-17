module PackageRepository
  module Debian
    module Client
      class Log < ::Log
        def tag!(tags)
          tags << :package_repository_debian_client
          tags << :libraries
          tags << :verbose
        end
      end
    end
  end
end
