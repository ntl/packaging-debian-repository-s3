require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Fetch" do
      context "Not Found" do
        store = PackageIndex::Store.new

        store.distribution = Controls::Distribution.example

        package_index = store.fetch

        test "Returns empty data structure" do
          assert(package_index == PackageIndex.new)
        end
      end
    end
  end
end
