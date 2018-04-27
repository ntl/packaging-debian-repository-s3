require_relative '../../automated_init'

context "Package" do
  context "Get" do
    filename = Controls::Package.filename

    get_package = Package::Get.new

    control_data = 'some-data'
    data_source = StringIO.new(control_data)

    object_key = Controls::Package::Path.example(filename)

    get_object = get_package.get_object
    get_object.add(object_key, data_source)

    data_stream = get_package.(filename)

    test "Returns data stream" do
      get_data = String.new

      get_data << data_stream.read until data_stream.eof?

      assert(get_data == control_data)
    end
  end
end
