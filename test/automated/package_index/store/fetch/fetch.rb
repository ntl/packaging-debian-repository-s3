require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Fetch" do
      store = PackageIndex::Store.new

      store.distribution = Controls::Distribution.example

      object_key = Controls::PackageIndex::Path::Default.example

      data_stream = Controls::PackageIndex::Text::Compressed.stream

      get_object = store.get_object
      get_object.add(object_key, data_stream)

      package_index = store.fetch

      test "Returns index" do
        assert(package_index == Controls::PackageIndex.example)
      end
    end
  end
end
