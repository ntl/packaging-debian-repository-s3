require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Get" do
      distribution = Controls::Distribution.example

      store = Release::Store.new

      store.distribution = distribution

      object_key = Controls::Release::Path.example(distribution)

      data_source = Controls::Release::Text::Signed.stream

      get_object = store.get_object
      get_object.add(object_key, data_source)

      release = store.get

      test "Returns release" do
        assert(release == Controls::Release.example)
      end
    end
  end
end
