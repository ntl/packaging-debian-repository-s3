require_relative '../automated_init'

context "Get Package Index" do
  context "Not Found" do
    get_package_index = PackageIndex::Get.new

    get_package_index.()

    package_index = get_package_index.()

    test "Returns nil" do
      assert(package_index.nil?)
    end
  end
end
