require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Get" do
      context "Not Found" do
        distribution = Controls::Distribution.example

        store = Release::Store.new(distribution)

        release = store.get

        test "Returns nothing" do
          assert(release.nil?)
        end
      end
    end
  end
end
