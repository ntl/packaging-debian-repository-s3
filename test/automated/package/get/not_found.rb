require_relative '../../automated_init'

context "Package" do
  context "Get" do
    context "Not Found" do
      filename = Controls::Package.filename

      get_package = Package::Get.new

      data_stream = get_package.(filename)

      test "Returns nothing" do
        assert(data_stream.nil?)
      end
    end
  end
end
