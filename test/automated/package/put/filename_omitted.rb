require_relative '../../automated_init'

context "Package" do
  context "Put" do
    context "Filename Omitted" do
      data_stream = StringIO.new('some-data')

      put_package = Package::Put.new

      test "Raises ArgumentError" do
        assert proc { put_package.(data_stream) } do
          raises_error?(ArgumentError)
        end
      end
    end
  end
end
