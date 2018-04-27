require_relative '../../automated_init'

context "Package" do
  context "Put" do
    context "File Given" do
      file = Tempfile.new('example-file')

      control_filename = File.basename(file)

      put_package = Package::Put.new

      put_object = put_package.put_object

      put_package.(file)

      test "Filename is inferred from basename of file" do
        control_path = Controls::Package::Path.example(control_filename)

        assert put_object do
          put? do |object_key|
            object_key == control_path
          end
        end
      end
    end
  end
end
