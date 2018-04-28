require_relative '../../automated_init'

context "Package Index" do
  context "Store" do
    context "Constructed By Path" do
      distribution = Controls::Distribution::Alternate.example
      component = Controls::Component::Alternate.example
      architecture = Controls::Architecture::Alternate.example

      path = Controls::PackageIndex::Path.example(
        distribution: distribution,
        component: component,
        architecture: architecture
      )

      store = PackageIndex::Store.build(path)

      test "Distribution" do
        assert(store.distribution == distribution)
      end

      test "Component" do
        assert(store.component == component)
      end

      test "Architecture" do
        assert(store.architecture == architecture)
      end
    end
  end
end
