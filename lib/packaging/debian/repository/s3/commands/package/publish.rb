module Packaging
  module Debian
    module Repository
      module S3
        module Commands
          module Package
            class Publish
              include Log::Dependency

              configure :publish_package

              attr_accessor :distribution

              attr_writer :component
              def component
                @component ||= Defaults.component
              end

              dependency :put_object, AWS::S3::Client::Object::Put
              dependency :register_package, Register

              def configure
                AWS::S3::Client::Object::Put.configure(self)
                Register.configure(self, distribution)
              end

              def self.build(distribution=nil)
                instance = new
                instance.distribution = distribution unless distribution.nil?
                instance.configure
                instance
              end

              def self.call(deb_file, distribution: nil, component: nil)
                instance = build(distribution)
                instance.(deb_file, component: component)
              end

              def call(deb_file, component: nil, distribution: nil)
                distribution ||= self.distribution
                component ||= self.component

                filename = File.basename(deb_file)

                object_key = object_key(filename)

                logger.trace { "Publishing package (File: #{filename.inspect}, Object Key: #{object_key.inspect}, Distribution: #{distribution.inspect}, Component: #{component.inspect})" }

                if distribution.nil?
                  error_message = "Distribution not specified (File: #{filename.inspect}, Object Key: #{object_key.inspect}, Distribution: #{distribution.inspect}, Component: #{component.inspect})"
                  logger.error { error_message }
                  raise MissingDistributionError, error_message
                end

                unless File.size?(deb_file)
                  error_message = "File not found (File: #{filename.inspect}, Object Key: #{object_key.inspect}, Distribution: #{distribution.inspect}, Component: #{component.inspect})"
                  logger.error { error_message }
                  raise FileNotFoundError, error_message
                end

                begin
                  package_metadata = Schemas::Package::Read.(deb_file)
                rescue Schemas::Package::Read::Failure
                  error_message = "Malformed debian file (File: #{filename.inspect}, Object Key: #{object_key.inspect}, Distribution: #{distribution.inspect}, Component: #{component.inspect})"
                  logger.error { error_message }
                  raise MalformedPackageFileError, error_message
                end

                index_entry = PackageIndex::Entry.build

                SetAttributes.(index_entry, package_metadata)

                index_entry.filename = filename
                index_entry.size = ::File.size(deb_file)

                calculate_sha256 = ::Digest::SHA2.new(256)

                index_entry.sha256 = Schemas::SHA256.(deb_file)

                File.open(deb_file) do |file|
                  file.rewind

                  put_object.(object_key, file)
                end

                register_package.(index_entry, component: component)

                logger.info { "Package published (File: #{filename.inspect}, Object Key: #{object_key.inspect}, Distribution: #{distribution.inspect}, Component: #{component.inspect})" }

                index_entry
              end

              def object_key(filename)
                ::File.join(
                  'pool',
                  filename[0],
                  filename
                )
              end

              FileNotFoundError = Class.new(StandardError)
              MalformedPackageFileError = Class.new(StandardError)
              MissingDistributionError = Class.new(StandardError)
            end
          end
        end
      end
    end
  end
end
