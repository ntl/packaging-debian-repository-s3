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

    put_text = String.new

    put_package_index.(package_index, put_text)

    test "Data is compressed" do
      assert(put_text == Controls::PackageIndex::Text::GZip.example)
    end

    test "Index is uploaded to repository" do
      control_path = Controls::PackageIndex::Path.example

      assert put_object do
        put? do |object_key|
          object_key == control_path
        end
      end
    end
  end
end
