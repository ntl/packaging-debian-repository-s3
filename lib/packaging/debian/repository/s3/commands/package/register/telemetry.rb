module Packaging
  module Debian
    module Repository
      module S3
        module Commands
          module Package
            class Register
              module Telemetry
                class Sink
                  include ::Telemetry::Sink

                  record :put_package_index
                  record :put_release
                end

                PutPackageIndex = Struct.new(
                  :package_index,
                  :remote_path,
                  :text,
                  :size,
                  :sha256
                )

                PutRelease = Struct.new(:release, :remote_path, :text)
              end
            end
          end
        end
      end
    end
  end
end
