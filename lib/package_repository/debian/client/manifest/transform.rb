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
            fail
          end

          module RFC822
            def self.read(compressed_text)
              input_io = StringIO.new(compressed_text)

              gzip_reader = Zlib::GzipReader.new(input_io)

              packages = []

              index = 0

              until gzip_reader.eof?
                line = gzip_reader.gets

                if line =~ %r{^[[:blank:]]*$}
                  index += 1
                  next
                end

                pattern = %r{^(?<field>[[:graph:]]*?):[[:blank:]](?<value>.*)}

                match_data = pattern.match(line)

                fail if match_data.nil?

                field = match_data['field']

                value = match_data['value']

                field = field.downcase.to_sym

                packages[index] ||= {}
                packages[index][field] = value
              end

              gzip_reader.close

              packages
            end

            def self.write(manifest)
            end
          end
        end
      end
    end
  end
end
