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

            gzip_reader = ::Zlib::GzipReader.new(data_source)

            package_index_text = gzip_reader.read

            gzip_reader.close

            package_index = ::Transform::Read.(
              package_index_text,
              :rfc822,
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
