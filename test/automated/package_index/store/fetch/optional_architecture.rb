require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Fetch" do
      context "Optional Architecture" do
        distribution = Controls::Distribution.example

        store = PackageIndex::Store.new(distribution)

        architecture = Controls::Architecture::Alternate.example

        object_key = Controls::PackageIndex::Path::Default.example(
          architecture: architecture
        )

        data_stream = Controls::PackageIndex::Text::Compressed.stream

        get_object = store.get_object
        get_object.add(object_key, data_stream)

        package_index = store.fetch(architecture: architecture)

        test "Retrieves index for given architecture" do
          assert(package_index == Controls::PackageIndex.example)
        end
      end
    end
  end
end
