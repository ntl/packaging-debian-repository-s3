module Packaging
  module Debian
    module Repository
      class Log < ::Log
        def tag!(tags)
          tags << :packaging_debian_repository
          tags << :packaging
          tags << :libraries
          tags << :verbose
        end
      end
    end
  end
end
