require_relative '../../automated_init'

context "Commands" do
  context "Register Package" do
    context "Release File is Updated" do
      index_entry = Controls::PackageIndex::Entry.example

      distribution = Controls::Distribution.example
      component = Controls::Random.unique_text
      architecture = index_entry.architecture or fail

      package_index_path = Controls::PackageIndex::Path::Relative.example(component: component, architecture: architecture)

      prior_release = Controls::Release::Alternate.example
      refute(prior_release.components.include?(component))
      refute(prior_release.components.empty?)
      refute(prior_release.architectures.include?(architecture))
      refute(prior_release.architectures.empty?)
      refute(prior_release.files.empty?)
      refute(prior_release.added_file?(package_index_path))

      register_package = Commands::Package::Register.new(distribution)

      release_store = register_package.release_store
      release_store.add(prior_release)

      telemetry_sink = Commands::Package::Register.register_telemetry_sink(register_package)

      register_package.(index_entry, component: component)

      context "Updated Release File" do
        telemetry_record = telemetry_sink.one_record do |record|
          record.signal == :put_release
        end
        refute(telemetry_record.nil?)

        put_release = telemetry_record.data.release

        test "Component is added to list of components" do
          assert(put_release.components.include?(component))
        end

        test "Architecture is added to list of architectures" do
          assert(put_release.architectures.include?(architecture))
        end

        test "Package index file for component and architecture is added" do
          assert(put_release.added_file?(package_index_path))
        end

        test "Previous package index files are retained" do
          assert(put_release.files.count > 1)
        end
      end
    end
  end
end
