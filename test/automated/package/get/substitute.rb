require_relative '../../automated_init'

context "Package" do
  context "Get" do
    context "Substitute" do
      filename = Controls::Package.filename

      control_data = 'some-data'

      substitute = Dependency::Substitute.build(Package::Get)

      substitute.add(filename, control_data)

      context "Filename Is Added" do
        data_stream = substitute.(filename)

        test "Returns data stream containing given data" do
          assert(data_stream.read == control_data)
        end
      end

      context "Filename Not Added" do
        other_filename = Controls::Random.unique_text

        data_stream = substitute.(other_filename)

        test "Returns nothing" do
          assert(data_stream.nil?)
        end
      end
    end
  end
end
