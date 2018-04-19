module PackageRepository
  module Debian
    module Client
      class PackageIndex
        class Put
          include Log::Dependency

          configure :put_package_index

          setting :suite
          setting :component
          setting :architecture

          dependency :put_object, AWS::S3::Client::Object::Put

          def configure
            AWS::S3::Client::Object::Put.configure(self)
          end

          def self.build
            instance = new
            instance.configure
            instance
          end

          def self.call(package_index)
            instance = build
            instance.(package_index)
          end

          def call(package_index)
            text = ::Transform::Write.(package_index, :rfc822)

            object_key = path

            compressed_text = String.new
            compressed_text.encode('ASCII-8BIT')

            stringio = StringIO.new(compressed_text)

            gzip_writer = ::Zlib::GzipWriter.new(stringio)
            gzip_writer.write(text)
            gzip_writer.close

            put_object.(object_key, compressed_text, acl: 'public-read')
          end

          def self.compress(text)
            compressed_text = String.new

            compressed_text
          end

          def path
            File.join('dists', suite.to_s, component.to_s, "binary-#{architecture}", 'Packages.gz')
          end
        end
      end
    end
  end
end
