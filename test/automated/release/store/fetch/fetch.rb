require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Fetch" do
      distribution = Controls::Distribution.example

      store = Release::Store.new(distribution)

      object_key = Controls::Release::Path.example(distribution)

      data_source = Controls::Release::Text::Signed.stream

      get_object = store.get_object
      get_object.add(object_key, data_source)

      release = store.fetch

      test "Returns release" do
        assert(release == Controls::Release.example)
      end
    end
  end
end
