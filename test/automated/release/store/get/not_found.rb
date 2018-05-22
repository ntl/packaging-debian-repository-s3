require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Get" do
      context "Not Found" do
        store = Release::Store.new

        store.distribution = Controls::Distribution.example

        release = store.get

        test "Returns nothing" do
          assert(release.nil?)
        end
      end
    end
  end
end
