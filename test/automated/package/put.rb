require_relative '../automated_init'

context "Package" do
  context "Put" do
    package = Controls::Package.example

    put_package = Package::Put.new

    put_package.suite = suite = Controls::Suite.example
    put_package.component = component = Controls::Component.example
    put_package.architecture = architecture = Controls::Architecture.example

    put_object = put_package.put_object

    put_package.(package)

    test "Package is uploaded to repository" do
      control_text = File.read(package)
      control_path = Controls::Package::Path.example

      assert put_object do
        put? do |object_key, data|
          put_text = File.read(data.data_source.path)

          object_key == control_path && put_text == control_text
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
