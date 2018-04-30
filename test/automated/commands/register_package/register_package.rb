require_relative '../../automated_init'

context "Commands" do
  context "Register Package" do
    index_entry = Controls::PackageIndex::Entry.example

    distribution = Controls::Distribution.example
    component = Controls::Component.example
    architecture = index_entry.architecture or fail

    register_package = Commands::Package::Register.new(distribution)

    effective_time = Controls::Time::Raw.example
    register_package.clock.now = effective_time

    telemetry_sink = Commands::Package::Register.register_telemetry_sink(register_package)

    register_package.(index_entry, component: component)

    package_index_telemetry_record = telemetry_sink.one_record do |record|
      record.signal == :put_package_index
    end

    context "Uploaded Package Index" do
      telemetry_record = package_index_telemetry_record

      telemetry_data = telemetry_record.data

      remote_path = telemetry_data.remote_path

      package_index = telemetry_data.package_index

      context "Telemetry Record" do
        test "Recorded" do
          refute(telemetry_record.nil?)
        end

        context "Data" do
          test "Package index" do
            control_package_index = Controls::PackageIndex.example(entries: [index_entry])

            assert(package_index == control_package_index)
          end

          test "Remote Path" do
            control_remote_path = Controls::PackageIndex::Path.example(
              distribution: distribution,
              component: component,
              architecture: architecture
            )

            assert(remote_path == control_remote_path)
          end

          package_index_text = telemetry_data.text

          test "Text" do
            put_package_index = Transform::Read.(package_index_text, :rfc822_compressed, PackageIndex)

            assert(put_package_index == package_index)
          end

          test "Size" do
            assert(telemetry_data.size == package_index_text.bytesize)
          end

          test "SHA256" do
            sha256 = Digest::SHA256.hexdigest(package_index_text)

            assert(telemetry_data.sha256 == sha256)
          end
        end
      end

      context "Upload" do
        store = register_package.package_index_store

        test "Package index is uploaded" do
          uploaded = store.put? do |uploaded_package_index|
            uploaded_package_index == package_index
          end

          assert(uploaded)
        end

        test "Remote Path" do
          uploaded = store.put? do |_, object_key|
            object_key == remote_path
          end

          assert(uploaded)
        end
      end
    end

    context "Uploaded Release File" do
      telemetry_record = telemetry_sink.one_record do |record|
        record.signal == :put_release
      end

      telemetry_data = telemetry_record.data

      remote_path = telemetry_data.remote_path

      release = telemetry_data.release

      package_index_data = package_index_telemetry_record.data

      context "Telemetry Record" do
        test "Recorded" do
          refute(telemetry_record.nil?)
        end

        context "Data" do
          test "Release file includes package index, both uncompressed and compressed" do
            relative_path = File.join(component, "binary-#{architecture}", 'Packages.gz')

            compressed_index = {
              :filename => relative_path,
              :size => package_index_data.size,
              :sha256 => package_index_data.sha256
            }

            uncompressed_text = Transform::Write.(package_index_data.package_index, :rfc822)

            uncompressed_index = {
              :filename => File.basename(relative_path, '.gz'),
              :size => uncompressed_text.bytesize,
              :sha256 => Digest::SHA256.hexdigest(uncompressed_text)
            }

            files = [compressed_index, uncompressed_index]

            control_release = Controls::Release::Minimal.example(files: files)

            assert(release == control_release)
          end

          test "Remote Path" do
            control_remote_path = Controls::Release::Path.example(distribution)

            assert(remote_path == control_remote_path)
          end

          test "Text" do
            release_text = telemetry_data.text

            put_release = Transform::Read.(release_text, :rfc822_signed, Release)

            assert(put_release == release)
          end
        end
      end

      context "Upload" do
        store = register_package.release_store

        test "Release is uploaded" do
          uploaded = store.put? do |uploaded_release|
            uploaded_release == release
          end

          assert(uploaded)
        end

        test "Remote Path" do
          uploaded = store.put? do |_, object_key|
            object_key == remote_path
          end

          assert(uploaded)
        end
      end
    end
  end
end
