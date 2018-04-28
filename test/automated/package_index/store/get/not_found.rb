require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Get" do
      context "Not Found" do
        distribution = Controls::Distribution.example

        store = PackageIndex::Store.new(distribution)

        package_index = store.get

        test "Returns nil" do
          assert(package_index.nil?)
        end
      end
    end
  end
end
