require_relative '../automated_init'

context "Package Index" do
  context "Put" do
    package_index = Controls::PackageIndex.example

    put_package_index = PackageIndex::Put.new

    put_package_index.suite = suite = Controls::Suite.example
    put_package_index.component = component = Controls::Component.example
    put_package_index.architecture = architecture = Controls::Architecture.example

    package_index_path = Controls::PackageIndex::Path.example

    put_object = put_package_index.put_object

    put_package_index.(package_index)

    test "Index is compressed and uploaded to repository" do
      control_text = Controls::PackageIndex::Text::GZip.example
      control_path = Controls::PackageIndex::Path.example

      assert put_object do
        put? do |object_key, data|
          object_key == control_path && data.data_source == control_text
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
