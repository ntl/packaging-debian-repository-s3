require_relative '../../automated_init'

context "Commands" do
  context "Register Package" do
    context "Package Index is Updated" do
      prior_index_entry = Controls::PackageIndex::Entry.example
      index_entry = Controls::PackageIndex::Entry::Alternate.example

      refute(index_entry.filename == prior_index_entry.filename)

      distribution = Controls::Distribution.example
      component = Controls::Component.example
      architecture = index_entry.architecture or fail

      package_index = Controls::PackageIndex.example(entries: [prior_index_entry])
      assert(package_index.added?(prior_index_entry.filename))

      register_package = Commands::Package::Register.new
      register_package.distribution = distribution

      package_index_store = register_package.package_index_store
      package_index_store.add(package_index, distribution: distribution, component: component, architecture: architecture)

      telemetry_sink = Commands::Package::Register.register_telemetry_sink(register_package)

      register_package.(index_entry, component: component)

      context "Updated Package Index" do
        telemetry_record = telemetry_sink.one_record do |record|
          record.signal == :put_package_index
        end
        refute(telemetry_record.nil?)

        put_package_index = telemetry_record.data.package_index

        test "Package file is added to index" do
          assert(put_package_index.added?(index_entry.filename))
        end

        test "Previous package is retained" do
          assert(put_package_index.added?(prior_index_entry.filename))
        end
      end
    end
  end
end
