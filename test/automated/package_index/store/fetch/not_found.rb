require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Fetch" do
      context "Not Found" do
        distribution = Controls::Distribution.example

        store = PackageIndex::Store.new(distribution)

        package_index = store.fetch

        test "Returns empty data structure" do
          assert(package_index == PackageIndex.new)
        end
      end
    end
  end
end
