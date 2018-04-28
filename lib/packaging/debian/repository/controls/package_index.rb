module Packaging
  module Debian
    module Repository
      module Controls
        PackageIndex = Packaging::Debian::Schemas::Controls::Repository::PackageIndex

        module PackageIndex
          module Text
            module Compressed
              def self.example
                text = Text.example

                compressed_text = String.new
                compressed_text.encode('ASCII-8BIT')

                stringio = StringIO.new(compressed_text)

                gzip_writer = ::Zlib::GzipWriter.new(stringio)
                gzip_writer.write(text)
                gzip_writer.close

                compressed_text
              end

              def self.stream
                StringIO.new(example)
              end
            end
          end

          module Path
            def self.example(distribution: nil, component: nil, architecture: nil)
              distribution ||= Distribution.example
              component ||= Component.example
              architecture ||= Architecture.example

              "dists/#{distribution}/#{component}/binary-#{architecture}/Packages.gz"
            end
          end
        end
      end
    end
  end
end
