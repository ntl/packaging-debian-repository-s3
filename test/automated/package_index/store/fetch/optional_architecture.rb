require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Fetch" do
      context "Optional Architecture" do
        distribution = Controls::Distribution.example

        store = PackageIndex::Store.new(distribution)

        architecture = Controls::Architecture::Alternate.example

        object_key = Controls::PackageIndex::Path.example(
          distribution: distribution,
          architecture: architecture
        )

        data_stream = Controls::PackageIndex::Text::Compressed.stream

        get_object = store.get_object
        get_object.add(object_key, data_stream)

        package_index = store.fetch

        test "Retrieves index for given architecture" do
          refute(package_index.nil?)
        end
      end
    end
  end
end
