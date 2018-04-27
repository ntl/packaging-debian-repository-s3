require_relative '../../automated_init'

context "Package" do
  context "Get" do
    filename = Controls::Package.filename

    get_package = Package::Get.new

    get_package.suite = suite = Controls::Suite.example
    get_package.component = component = Controls::Component.example
    get_package.architecture = architecture = Controls::Architecture.example

    control_data = 'some-data'
    data_source = StringIO.new(control_data)

    get_object = get_package.get_object
    get_object.add(
      "dists/#{suite}/#{component}/binary-#{architecture}/#{filename}",
      data_source
    )

    data_stream = get_package.(filename)

    test "Returns data stream" do
      get_data = String.new

      get_data << data_stream.read until data_stream.eof?

      assert(get_data == control_data)
    end
  end
end
