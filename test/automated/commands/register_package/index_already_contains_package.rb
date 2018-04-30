require_relative '../../automated_init'

context "Commands" do
  context "Register Package" do
    context "Index Already Contains Package" do
      prior_index_entry = Controls::PackageIndex::Entry.example
      index_entry = Controls::PackageIndex::Entry::Alternate.example(filename: prior_index_entry.filename)

      assert(index_entry.filename == prior_index_entry.filename)
      refute(index_entry == prior_index_entry)

      package_index = Controls::PackageIndex.example(entries: [prior_index_entry])

      distribution = Controls::Distribution.example
      architecture = index_entry.architecture or fail

      register_package = Commands::Package::Register.new(distribution)

      package_index_store = register_package.package_index_store
      package_index_store.add(package_index)

      test "Does not raise error" do
        refute proc { register_package.(index_entry) } do
          raises_error?(Packaging::Debian::Schemas::PackageIndex::EntryAddedError)
        end
      end

      test "Overwrites existing package information" do
        overwritten = package_index_store.put? do |package_index|
          package_index.entries == [index_entry]
        end

        assert(overwritten)
      end
    end
  end
end
