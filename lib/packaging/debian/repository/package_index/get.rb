module Packaging
  module Debian
    module Repository
      class PackageIndex
        class Get
          include Log::Dependency

          configure :get_package_index

          setting :suite
          setting :component
          setting :architecture

          dependency :get_object, AWS::S3::Client::Object::Get

          def configure
            AWS::S3::Client::Object::Get.configure(self)
          end

          def self.build
            instance = new
            instance.configure
            instance
          end

          def self.call
            instance = build
            instance.()
          end

          def call
            logger.trace { "Getting package index (Path: #{path.inspect})" }

            begin
              data_source = get_object.(path)
            rescue AWS::S3::Client::Object::Get::ObjectNotFound
              return nil
            end

            compressed_text = String.new

            compressed_text << data_source.read until data_source.eof?

            package_index = ::Transform::Read.(
              compressed_text,
              :rfc822_compressed,
              PackageIndex
            )

            logger.info { "Get package index done (Path: #{path.inspect})" }

            package_index
          end

          def path
            ::File.join(
              'dists',
              suite.to_s,
              component.to_s,
              "binary-#{architecture}",
              'Packages.gz'
            )
          end
        end
      end
    end
  end
end
