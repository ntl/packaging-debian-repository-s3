module PackageRepository
  module Debian
    module Client
      module Controls
        module Package
          def self.example(**args)
            data = self.data(**args)

            Client::Package.build(data)
          end

          def self.data(package: nil, source: nil, version: nil, section: nil, priority: nil, architecture: nil, essential: nil, depends: nil, pre_depends: nil, recommends: nil, suggests: nil, enhances: nil, breaks: nil, conflicts: nil, installed_size: nil, maintainer: nil, description: nil, homepage: nil, built_using: nil, default_source: nil)
            default_source ||= Attributes

            data = {}

            Attributes.list.each do |attribute|
              value = binding.local_variable_get(attribute)

              next if value == :none

              if value.nil?
                value = default_source.public_send(attribute)
              end

              data[attribute] = value
            end

            data
          end
        end
      end
    end
  end
end
