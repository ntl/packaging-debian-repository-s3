require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Fetch" do
      context "Optional Arguments" do
        distribution = Controls::Distribution.example

        store = PackageIndex::Store.new(distribution)

        component = Controls::Component::Alternate.example
        architecture = Controls::Architecture::Alternate.example

        object_key = Controls::PackageIndex::Path.example(
          distribution: distribution,
          component: component,
          architecture: architecture
        )

        data_stream = Controls::PackageIndex::Text::Compressed.stream

        get_object = store.get_object
        get_object.add(object_key, data_stream)

        package_index = store.fetch

        test "Returns index located by optional arguments" do
          refute(package_index.nil?)
        end
      end
    end
  end
end
