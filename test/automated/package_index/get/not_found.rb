require_relative '../../automated_init'

context "Package Index" do
  context "Get" do
    context "Not Found" do
      distribution = Controls::Distribution.example

      get_package_index = PackageIndex::Get.new(distribution)

      component = Controls::Component.example
      architecture = Controls::Architecture.example

      package_index = get_package_index.(component, architecture)

      test "Returns nil" do
        assert(package_index.nil?)
      end
    end
  end
end
