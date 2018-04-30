module Packaging
  module Debian
    module Repository
      module S3
        module Commands
          module Package
            class Publish
              include Log::Dependency

              configure :publish_package

              attr_writer :component
              def component
                @component ||= Defaults.component
              end

              dependency :put_object, AWS::S3::Client::Object::Put
              dependency :register_package, Register

              def configure
                AWS::S3::Client::Object::Put.configure(self)
                Register.configure(self)
              end

              initializer :distribution

              def self.build(distribution)
                instance = new(distribution)
                instance.configure
                instance
              end

              def self.call(deb_file, distribution, component: nil)
                instance = build(distribution)
                instance.(deb_file, component: component)
              end

              def call(deb_file, component: nil)
                component ||= self.component

                filename = File.basename(deb_file)

                object_key = object_key(filename)

                logger.trace { "Publishing package (File: #{filename.inspect}, Object Key: #{object_key.inspect}, Component: #{component.inspect})" }

                package_metadata = Schemas::Package::Read.(deb_file)

                index_entry = PackageIndex::Entry.build

                SetAttributes.(index_entry, package_metadata)

                index_entry.filename = filename
                index_entry.size = ::File.size(deb_file)

                calculate_sha256 = ::Digest::SHA2.new(256)

                File.open(deb_file) do |file|
                  calculate_sha256 << file.read until file.eof?

                  file.rewind

                  put_object.(object_key, file)
                end

                index_entry.sha256 = calculate_sha256.hexdigest

                register_package.(index_entry, component: component)

                logger.info { "Package published (File: #{filename.inspect}, Object Key: #{object_key.inspect}, Component: #{component.inspect})" }

                index_entry
              end

              def object_key(filename)
                ::File.join(
                  'pool',
                  filename[0],
                  filename
                )
              end
            end
          end
        end
      end
    end
  end
end
