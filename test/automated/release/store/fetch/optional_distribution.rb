require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Fetch" do
      context "Optional Distribution" do
        store = Release::Store.new

        store.distribution = Controls::Distribution::Alternate.example

        distribution = Controls::Distribution.example

        object_key = Controls::Release::Path.example(distribution)

        data_source = Controls::Release::Text::Signed.stream

        get_object = store.get_object
        get_object.add(object_key, data_source)

        release = store.fetch(distribution: distribution)

        test "Returns release corresponding to given distribution" do
          assert(release == Controls::Release.example)
        end
      end
    end
  end
end
