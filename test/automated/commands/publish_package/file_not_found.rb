require_relative '../../automated_init'

context "Commands" do
  context "Publish Package" do
    context "File Not Found" do
      deb_file = File.join('tmp', Controls::Random.unique_text, 'some-pkg.deb')

      publish_package = Commands::Package::Publish.new

      publish_package.distribution = Controls::Distribution.example

      test "Raises error" do
        assert proc { publish_package.(deb_file) } do
          raises_error?(Commands::Package::Publish::FileNotFoundError)
        end
      end
    end
  end
end
