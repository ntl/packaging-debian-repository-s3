require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Get" do
      context "Optional Component" do
        distribution = Controls::Distribution.example

        context "Given" do
          component = Controls::Random.unique_text

          store = PackageIndex::Store.new

          store.distribution = distribution

          object_key = Controls::PackageIndex::Path::Default.example(
            component: component
          )

          data_source = Controls::PackageIndex::Text::Compressed.stream

          get_object = store.get_object
          get_object.add(object_key, data_source)

          package_index = store.get(component: component)

          test "Retrieves index for given component" do
            refute(package_index.nil?)
          end
        end

        context "Omitted" do
          default_component = Defaults.component

          store = PackageIndex::Store.new

          store.distribution = distribution

          object_key = Controls::PackageIndex::Path::Default.example

          data_source = Controls::PackageIndex::Text::Compressed.stream

          get_object = store.get_object
          get_object.add(object_key, data_source)

          package_index = store.get

          test "Retrieves index for default component" do
            refute(package_index.nil?)
          end
        end
      end
    end
  end
end
