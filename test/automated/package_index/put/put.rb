require_relative '../../automated_init'

context "Package Index" do
  context "Put" do
    distribution = Controls::Distribution.example

    put_package_index = PackageIndex::Put.new(distribution)

    component = Controls::Component.example
    architecture = Controls::Architecture.example

    package_index = Controls::PackageIndex.example

    put_package_index.(package_index, component, architecture)

    put_object = put_package_index.put_object

    test "Index is compressed and uploaded to repository" do
      control_text = Controls::PackageIndex::Text::GZip.example

      control_object_key = Controls::PackageIndex::Path.example(
        distribution: distribution,
        component: component,
        architecture: architecture
      )

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
