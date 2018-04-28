require_relative '../../automated_init'

context "Package Index" do
  context "Get" do
    context "Constructed By Path" do
      distribution = Controls::Distribution::Alternate.example
      component = Controls::Component::Alternate.example
      architecture = Controls::Architecture::Alternate.example

      path = Controls::PackageIndex::Path.example(
        distribution: distribution,
        component: component,
        architecture: architecture
      )

      get_package_index = PackageIndex::Get.build(path)

      test "Distribution" do
        assert(get_package_index.distribution == distribution)
      end

      test "Component" do
        assert(get_package_index.component == component)
      end

      test "Architecture" do
        assert(get_package_index.architecture == architecture)
      end
    end
  end
end
