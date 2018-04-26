module Packaging
  module Debian
    module Repository
      class Settings < ::Settings
        def self.data_source
          'settings/debian_repository.json'
        end
      end
    end
  end
end
