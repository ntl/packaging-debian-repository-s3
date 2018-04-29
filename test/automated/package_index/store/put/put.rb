require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Put" do
      distribution = Controls::Distribution.example

      store = PackageIndex::Store.new(distribution)

      package_index = Controls::PackageIndex.example

      control_text = Controls::PackageIndex::Text::Compressed.example
      control_object_key = Controls::PackageIndex::Path.example(distribution: distribution)

      put_object = store.put_object

      put_key, put_text = store.put(package_index)

      context "Return Value" do
        test "First value is remote location" do
          assert(put_key == control_object_key)
        end

        test "Second value is raw, compressed text" do
          assert(put_text == control_text)
        end
      end

      test "Index is compressed and uploaded to repository" do
        assert put_object do
          put? do |object_key, data|
            object_key == control_object_key && data.data_source == control_text
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
