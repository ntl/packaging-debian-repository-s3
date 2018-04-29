require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Fetch" do
      context "Optional Distribution" do
        distribution = Controls::Distribution.example
        override_distribution = Controls::Random.unique_text

        store = PackageIndex::Store.new(distribution)

        object_key = Controls::PackageIndex::Path.example(
          distribution: override_distribution
        )

        data_stream = Controls::PackageIndex::Text::Compressed.stream

        get_object = store.get_object
        get_object.add(object_key, data_stream)

        package_index = store.fetch(distribution: override_distribution)

        test "Retrieves index for given distribution" do
          assert(package_index == Controls::PackageIndex.example)
        end
      end
    end
  end
end
