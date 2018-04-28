require_relative '../../automated_init'

context "Package Index" do
  context "Get" do
    context "Not Found" do
      distribution = Controls::Distribution.example

      get_package_index = PackageIndex::Get.new(distribution)

      package_index = get_package_index.()

      test "Returns nil" do
        assert(package_index.nil?)
      end
    end
  end
end
