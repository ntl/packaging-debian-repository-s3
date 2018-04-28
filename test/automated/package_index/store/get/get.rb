require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Get" do
      distribution = Controls::Distribution.example

      store = PackageIndex::Store.new(distribution)

      object_key = Controls::PackageIndex::Path.example(distribution: distribution)

      data_stream = Controls::PackageIndex::Text::Compressed.stream

      get_object = store.get_object
      get_object.add(object_key, data_stream)

      package_index = store.get

      test "Returns index" do
        assert(package_index == Controls::PackageIndex.example)
      end
    end
  end
end
