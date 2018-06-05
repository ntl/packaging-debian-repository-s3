module Packaging
  module Debian
    module Repository
      module S3
        module Commands
          module Package
            class Register
              include Log::Dependency
              include Telemetry::Dependency

              configure :register_package

              attr_accessor :distribution

              attr_writer :component
              def component
                @component ||= Defaults.component
              end

              dependency :clock, Clock::UTC
              dependency :package_index_store, PackageIndex::Store
              dependency :release_store, Release::Store

              def configure
                Clock::UTC.configure(self)
                PackageIndex::Store.configure(self, distribution, attr_name: :package_index_store)
                Release::Store.configure(self, distribution, attr_name: :release_store)
              end

              def self.build(distribution=nil)
                instance = new
                instance.distribution = distribution unless distribution.nil?
                instance.configure
                instance
              end

              def self.register_telemetry_sink(instance)
                sink = Telemetry::Sink.new

                instance.telemetry.register(sink)

                sink
              end

              def self.call(index_entry, distribution=nil, component: nil)
                instance = build(distribution)
                instance.(index_entry, component: component)
              end

              def call(index_entry, distribution: nil, component: nil)
                component ||= self.component
                distribution ||= self.distribution
                architecture = index_entry.architecture

                release = release_store.fetch

                if architecture == 'all'
                  architectures = release.architectures
                else
                  architectures = [architecture]
                end

                if architectures.empty?
                  error_message = "Could not register package, no suitable architectures found (Filename: #{index_entry.filename}, Component: #{component || '(default)'}, Architecture: #{architecture.inspect})"
                  logger.error { error_message }
                  raise UnknownArchitecturesError, error_message
                end

                architectures.each do |architecture|
                  register(index_entry, release, distribution, component, architecture)
                end
              end

              def register(index_entry, release, distribution, component, architecture)
                logger.trace { "Registering package index entry (Filename: #{index_entry.filename}, Component: #{component || '(default)'}, Architecture: #{architecture.inspect})" }

                index = package_index_store.fetch(
                  distribution: distribution,
                  component: component,
                  architecture: architecture
                )

                index.add_entry!(index_entry)

                compressed_index_path, compressed_index_text = package_index_store.put(
                  index,
                  distribution: distribution,
                  component: component,
                  architecture: architecture
                )

                compressed_index_size = compressed_index_text.bytesize
                compressed_index_sha256 = Digest::SHA256.hexdigest(compressed_index_text)

                telemetry.record(:put_package_index, Telemetry::PutPackageIndex.new(index, compressed_index_path, compressed_index_text, compressed_index_size, compressed_index_sha256))

                compressed_index_path = relative_path(compressed_index_path)

                release.suite = distribution
                release.architectures << architecture
                release.components << component
                release.date = clock.now

                release.add_file(
                  compressed_index_path,
                  compressed_index_size,
                  sha256: compressed_index_sha256
                )

                uncompressed_path = compressed_index_path.chomp('.gz')

                uncompressed_text = Transform::Write.(index, :rfc822)
                uncompressed_size = uncompressed_text.bytesize
                uncompressed_sha256 = Digest::SHA256.hexdigest(uncompressed_text)

                release.add_file(
                  uncompressed_path,
                  uncompressed_size,
                  sha256: uncompressed_sha256
                )

                release_path, release_text = release_store.put(
                  release,
                  distribution: distribution
                )

                telemetry.record(:put_release, Telemetry::PutRelease.new(release, release_path, release_text))

                logger.info { "Registered package index entry (Filename: #{index_entry.filename}, Component: #{component || '(default)'}, Architecture: #{architecture.inspect})" }
              end

              def relative_path(path)
                prefix = File.join('dists', distribution, '')

                path.delete_prefix(prefix)
              end

              UnknownArchitecturesError = Class.new(StandardError)
            end
          end
        end
      end
    end
  end
end
