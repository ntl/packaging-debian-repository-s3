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

          def call(package_index, put_text=nil)
            text = ::Transform::Write.(package_index, :rfc822)

            object_key = path

            stringio = StringIO.new(put_text)

            gzip_writer = ::Zlib::GzipWriter.new(stringio)
            gzip_writer.write(text)
            gzip_writer.close

            put_object.(object_key, gzip_writer)
          end

          def self.compress(text)
            compressed_text = String.new

            compressed_text
          end

          def path
            File.join('dists', suite.to_s, component.to_s, architecture.to_s, 'Packages.gz')
          end
        end
      end
    end
  end
end
