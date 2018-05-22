require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Fetch" do
      context "Not Found" do
        store = Release::Store.new

        store.distribution = Controls::Distribution.example

        release = store.fetch

        test "Returns empty data structure" do
          assert(release == Release.new)
        end
      end
    end
  end
end
