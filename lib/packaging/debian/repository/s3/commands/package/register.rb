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

              attr_writer :component
              def component
                @component ||= Defaults.component
              end

              dependency :clock, Clock::UTC
              dependency :package_index_store, PackageIndex::Store
              dependency :release_store, Release::Store

              def configure
                Clock::UTC.configure(self)
                PackageIndex::Store.configure(self, attr_name: :package_index_store)
                Release::Store.configure(self, attr_name: :release_store)
              end

              initializer :distribution

              def self.build(distribution)
                instance = new(distribution)
                instance.configure
                instance
              end

              def self.register_telemetry_sink(instance)
                sink = Telemetry::Sink.new

                instance.telemetry.register(sink)

                sink
              end

              def self.call(index_entry, distribution, component: nil)
                instance = build(distribution)
                instance.(index_entry, component: component)
              end

              def call(index_entry, component: nil)
                component ||= self.component
                architecture = index_entry.architecture

                logger.trace { "Registering package index entry (Filename: #{index_entry.filename}, Component: #{component || '(default)'}, Architecture: #{architecture.inspect})" }

                index = package_index_store.fetch(component: component)
                index.add_entry!(index_entry)

                compressed_index_path, compressed_index_text = package_index_store.put(
                  index,
                  distribution: distribution,
                  component: component,
                  architecture: architecture
                )

                compressed_index_path = relative_path(compressed_index_path)

                compressed_index_size = compressed_index_text.bytesize
                compressed_index_sha256 = Digest::SHA256.hexdigest(compressed_index_text)

                telemetry.record(:put_package_index, Telemetry::PutPackageIndex.new(index, compressed_index_path, compressed_index_text, compressed_index_size, compressed_index_sha256))

                release = release_store.fetch

                release.suite = distribution
                release.architectures << architecture
                release.components << component
                release.date = clock.now

                release.add_file(
                  compressed_index_path,
                  compressed_index_size,
                  sha256: compressed_index_sha256
                )

                uncompressed_path = File.basename(compressed_index_path, '.gz')

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
            end
          end
        end
      end
    end
  end
end
