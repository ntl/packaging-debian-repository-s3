require_relative '../../automated_init'

context "Commands" do
  context "Publish Package" do
    context "Optional Component" do
      deb_file = Controls::Package::File.example

      distribution = Controls::Distribution.example

      context "Given" do
        component = Controls::Component.example

        publish_package = Commands::Package::Publish.new

        publish_package.distribution = distribution

        index_entry = publish_package.(deb_file, component: component)

        test "Package is registered with given component" do
          control_object_key = Controls::PackageIndex::Path::Default.example(
            component: component
          )

          registered = publish_package.register_package.registered? do |_, component|
            component == component
          end

          assert(registered)
        end
      end

      context "Omitted" do
        publish_package = Commands::Package::Publish.new

        publish_package.distribution = distribution

        index_entry = publish_package.(deb_file)

        test "Package is registered with default component" do
          control_object_key = Controls::PackageIndex::Path::Default.example

          registered = publish_package.register_package.registered? do |_, component|
            component == Defaults.component
          end

          assert(registered)
        end
      end
    end
  end
end
