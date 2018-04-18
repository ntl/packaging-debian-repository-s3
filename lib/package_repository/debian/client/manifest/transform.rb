module PackageRepository
  module Debian
    module Client
      class Manifest
        module Transform
          def self.rfc822
            RFC822
          end

          def self.instance(raw_data)
            raw_data.map do |raw_package_data|
              package = Package.new

              raw_package_data.each do |field, raw_value|
                value =
                  case field
                  when :size then Integer(raw_value)
                  else raw_value
                  end

                package.public_send("#{field}=", value)
              end

              package
            end
          end

          def self.raw_data(instance)
            packages = instance.packages

            packages.map do |package|
              package.to_h
            end
          end

          module RFC822
            def self.read(compressed_text)
              input_io = StringIO.new(compressed_text)

              text = String.new

              gzip_reader = Zlib::GzipReader.new(input_io)

              until gzip_reader.eof?
                text.concat(gzip_reader.read)
              end

              gzip_reader.close

              Client::RFC822.read(text)
            end

            def self.write(raw_data)
              compressed_text = String.new

              output_io = StringIO.new(compressed_text)

              text = Client::RFC822.write(raw_data)

              gzip_writer = Zlib::GzipWriter.new(output_io)
              gzip_writer.write(text)
              gzip_writer.close

              compressed_text
            end
          end
        end
      end
    end
  end
end
