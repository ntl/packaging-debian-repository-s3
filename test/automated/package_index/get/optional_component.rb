require_relative '../../automated_init'

context "Package Index" do
  context "Get" do
    context "Optional Component" do
      distribution = Controls::Distribution.example

      compressed_text = Controls::PackageIndex::Text::GZip.example

      context "Given" do
        component = Controls::Random.unique_text

        get_package_index = PackageIndex::Get.new(distribution)
        get_package_index.component = component

        package_index_path = Controls::PackageIndex::Path.example(
          distribution: distribution,
          component: component
        )

        data_source = StringIO.new(compressed_text)

        get_object = get_package_index.get_object
        get_object.add(package_index_path, data_source)

        package_index = get_package_index.(component: component)

        test "Retrieves index for given component" do
          refute(package_index.nil?)
        end
      end

      context "Omitted" do
        default_component = Defaults.component

        get_package_index = PackageIndex::Get.new(distribution)

        package_index_path = Controls::PackageIndex::Path.example(
          distribution: distribution,
          component: default_component
        )

        data_source = StringIO.new(compressed_text)

        get_object = get_package_index.get_object
        get_object.add(package_index_path, data_source)

        package_index = get_package_index.()

        test "Retrieves index for default component" do
          refute(package_index.nil?)
        end
      end
    end
  end
end
