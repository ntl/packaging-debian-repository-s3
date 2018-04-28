module Packaging
  module Debian
    module Repository
      module S3
        class PackageIndex
          module Transform
            def self.rfc822_compressed
              RFC822Compressed
            end

            module RFC822Compressed
              def self.read(compressed_text)
                compressed_stream = StringIO.new(compressed_text)

                text = String.new

                gzip_reader = ::Zlib::GzipReader.new(compressed_stream)

                until gzip_reader.eof?
                  text << gzip_reader.read
                end

                Schemas::RFC822.read(text)
              end

              def self.write(raw_data)
                text = Schemas::RFC822.write(raw_data)

                compressed_text = String.new
                compressed_text.encode('ASCII-8BIT')

                compressed_stream = StringIO.new(compressed_text)

                gzip_writer = ::Zlib::GzipWriter.new(compressed_stream)
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
end
