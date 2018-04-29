require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Get" do
      context "Optional Distribution" do
        distribution = Controls::Distribution.example

        context "Given" do
          override_distribution = Controls::Distribution::Alternate.example

          store = PackageIndex::Store.new(distribution)

          object_key = Controls::PackageIndex::Path::Default.example(
            distribution: override_distribution
          )

          data_source = Controls::PackageIndex::Text::Compressed.stream

          get_object = store.get_object
          get_object.add(object_key, data_source)

          package_index = store.get(distribution: override_distribution)

          test "Retrieves index for given distribution" do
            refute(package_index.nil?)
          end
        end

        context "Omitted" do
          store = PackageIndex::Store.new(distribution)

          object_key = Controls::PackageIndex::Path::Default.example(
            distribution: distribution
          )

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
