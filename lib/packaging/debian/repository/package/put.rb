module Packaging
  module Debian
    module Repository
      module Package
        class Put
          include Log::Dependency

          configure :put_package

          dependency :put_object, AWS::S3::Client::Object::Put

          def configure
            AWS::S3::Client::Object::Put.configure(self)
          end

          def self.build
            instance = new
            instance.configure
            instance
          end

          def self.call(package)
            instance = build
            instance.(package)
          end

          def call(data_stream, filename=nil)
            if data_stream.respond_to?(:path)
              filename ||= ::File.basename(data_stream.path)
            end

            if filename.nil?
              error_message = "Filename not supplied and could not be inferred (Data Stream: #{data_stream.inspect})"
              logger.error { error_message }
              raise ArgumentError, error_message
            end

            object_key = object_key(filename)

            logger.trace { "Putting package (Object Key: #{object_key.inspect})" }

            put_object.(object_key, data_stream, acl: 'public-read')

            logger.info { "Put package done (Object Key: #{object_key.inspect})" }
          end

          def object_key(filename)
            ::File.join('pool', filename[0], filename)
          end

          module Substitute
            def self.build
              Put.new
            end

            class Put < Put
              def put?(filename=nil, &block)
                if filename.nil?
                  block ||= proc { true }
                else
                  block ||= proc { |object_key| object_key == object_key(filename) }
                end

                put_object.put?(&block)
              end
            end
          end
        end
      end
    end
  end
end
