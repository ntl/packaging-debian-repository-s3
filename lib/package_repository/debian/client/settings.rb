module PackageRepository
  module Debian
    module Client
      class Settings < ::Settings
        def self.data_source
          'settings/debian_repository_s3.json'
        end

        def self.set(receiver)
          instance = self.build
          instance.set(receiver)
        end
      end
    end
  end
end
