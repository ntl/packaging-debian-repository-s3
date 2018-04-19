require_relative '../../automated_init'

context "Package Index" do
  context "Get" do
    get_package_index = PackageIndex::Get.new

    get_package_index.suite = suite = Controls::Suite.example
    get_package_index.component = component = Controls::Component.example
    get_package_index.architecture = architecture = Controls::Architecture.example

    package_index_path = Controls::PackageIndex::Path.example

    package_index_text = Controls::PackageIndex::Text.example

    get_object = get_package_index.get_object

    get_object.add(
      "dists/#{suite}/#{component}/#{architecture}/Packages.gz",
      package_index_text
    )

    get_package_index.()

    package_index = get_package_index.()

    test "Returns index" do
      assert(package_index == Controls::PackageIndex.example)
    end
  end
end
