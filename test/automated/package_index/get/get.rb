require_relative '../../automated_init'

context "Package Index" do
  context "Get" do
    distribution = Controls::Distribution.example

    get_package_index = PackageIndex::Get.new(distribution)

    component = Controls::Component.example
    architecture = Controls::Architecture.example

    package_index_path = Controls::PackageIndex::Path.example(
      distribution: distribution,
      component: component,
      architecture: architecture
    )

    compressed_text = Controls::PackageIndex::Text::GZip.example
    data_source = StringIO.new(compressed_text)

    get_object = get_package_index.get_object
    get_object.add(package_index_path, data_source)

    package_index = get_package_index.(component, architecture)

    test "Returns index" do
      assert(package_index == Controls::PackageIndex.example)
    end
  end
end
