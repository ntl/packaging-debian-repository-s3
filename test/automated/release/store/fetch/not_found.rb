require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Fetch" do
      context "Not Found" do
        distribution = Controls::Distribution.example

        store = Release::Store.new(distribution)

        release = store.fetch

        test "Returns empty data structure" do
          assert(release == Release.new)
        end
      end
    end
  end
end
