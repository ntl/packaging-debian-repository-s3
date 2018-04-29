require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Fetch" do
      context "Optional Component" do
        distribution = Controls::Distribution.example

        store = PackageIndex::Store.new(distribution)

        component = Controls::Component::Alternate.example

        object_key = Controls::PackageIndex::Path::Default.example(
          component: component
        )

        data_stream = Controls::PackageIndex::Text::Compressed.stream

        get_object = store.get_object
        get_object.add(object_key, data_stream)

        package_index = store.fetch(component: component)

        test "Retrieves index for given component" do
          assert(package_index == Controls::PackageIndex.example)
        end
      end
    end
  end
end
