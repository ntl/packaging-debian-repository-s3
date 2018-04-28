require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Put" do
      distribution = Controls::Distribution.example

      release = Controls::Release.example

      store = Release::Store.new(distribution)
      store.put(release)

      put_object = store.put_object

      test "Release is uploaded to repository" do
        control_text = Controls::Release::Text.example
        control_object_key = Controls::Release::Path.example(distribution)

        assert put_object do
          put? do |object_key, data|
            unsigned_data = Controls::GPG::Clearsign::Signature::Remove.(data.data_source.string)

            object_key == control_object_key && unsigned_data == control_text
          end
        end
      end

      test "ACL is set to public read" do
        assert put_object do
          put? do |_, data|
            data.acl == 'public-read'
          end
        end
      end
    end
  end
end
