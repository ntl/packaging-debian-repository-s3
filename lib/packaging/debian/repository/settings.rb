module Packaging
  module Debian
    module Repository
      class Settings < ::Settings
        def self.data_source
          'settings/debian_repository.json'
        end

        def self.get(*args)
          instance = self.build
          instance.get(*args)
        end
      end
    end
  end
end
