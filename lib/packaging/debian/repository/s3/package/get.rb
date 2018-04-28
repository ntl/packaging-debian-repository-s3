module Packaging
  module Debian
    module Repository
      module S3
        module Package
          class Get
            include Log::Dependency

            configure :get_package

            dependency :get_object, AWS::S3::Client::Object::Get

            def configure
              AWS::S3::Client::Object::Get.configure(self)
            end

            def self.build
              instance = new
              instance.configure
              instance
            end

            def self.call(filename)
              instance = build
              instance.(filename)
            end

            def call(filename)
              object_key = object_key(filename)

              logger.trace { "Getting package (Object Key: #{object_key.inspect})" }

              begin
                data_stream = get_object.(object_key)
              rescue AWS::S3::Client::Object::Get::ObjectNotFound
                logger.warn { "Package file not found (Object Key: #{object_key.inspect})" }
                return nil
              end

              logger.info { "Get package done (Object Key: #{object_key.inspect})" }

              data_stream
            end

            def object_key(filename)
              ::File.join('pool', filename[0], filename)
            end
          end
        end
      end
    end
  end
end
