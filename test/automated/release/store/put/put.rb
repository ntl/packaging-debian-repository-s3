require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Put" do
      distribution = Controls::Distribution.example

      release = Controls::Release.example

      store = Release::Store.new

      store.distribution = distribution

      put_object = store.put_object

      put_key, put_text = store.put(release)

      context "Return Value" do
        test "First value is remote location" do
          assert(put_key == Controls::Release::Path.example)
        end

        test "Second value is raw, signed text" do
          unsigned_put_text = Controls::GPG::Clearsign::Signature::Remove.(put_text)

          assert(unsigned_put_text == Controls::Release::Text.example)
        end
      end

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

      test "ACL is set to private" do
        assert put_object do
          put? do |_, data|
            data.acl == 'private'
          end
        end
      end
    end
  end
end
