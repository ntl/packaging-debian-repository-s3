require_relative '../../automated_init'

context "Commands" do
  context "Publish Package" do
    context "Missing Distribution" do
      deb_file = Controls::Package::File.example

      publish_package = Commands::Package::Publish.new

      test "Raises error" do
        assert proc { publish_package.(deb_file) } do
          raises_error?(Commands::Package::Publish::MissingDistributionError)
        end
      end
    end
  end
end
