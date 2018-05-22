require_relative '../../automated_init'

context "Commands" do
  context "Publish Package" do
    context "Malformed Debian File" do
      deb_file = Controls::Package::File::Malformed.example

      publish_package = Commands::Package::Publish.new

      publish_package.distribution = Controls::Distribution.example

      test "Raises error" do
        assert proc { publish_package.(deb_file) } do
          raises_error?(Commands::Package::Publish::MalformedPackageFileError)
        end
      end
    end
  end
end
