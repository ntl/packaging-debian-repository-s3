require_relative '../../automated_init'

context "Package" do
  context "Put" do
    control_data = 'some-data'
    filename = Controls::Package.filename

    data_stream = StringIO.new(control_data)

    put_package = Package::Put.new

    put_object = put_package.put_object

    put_package.(data_stream, filename)

    test "Package is uploaded to repository" do
      control_path = Controls::Package::Path.example(filename)

      assert put_object do
        put? do |object_key, data|
          put_text = data.data_source.string

          object_key == control_path && put_text == control_data
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
