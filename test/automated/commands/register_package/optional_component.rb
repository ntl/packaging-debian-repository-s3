require_relative '../../automated_init'

context "Commands" do
  context "Register Package" do
    context "Optional Component" do
      index_entry = Controls::PackageIndex::Entry.example

      architecture = index_entry.architecture or fail

      context "Given" do
        component = Controls::Component::Alternate.example

        register_package = Commands::Package::Register.new
        register_package.distribution = Controls::Distribution.example

        register_package.(index_entry, component: component)

        test "Package index is uploaded to given component" do
          control_object_key = Controls::PackageIndex::Path.example(
            component: component,
            architecture: architecture
          )

          package_index_store = register_package.package_index_store

          uploaded_to_component = package_index_store.put? do |_, object_key|
            object_key == control_object_key
          end

          assert(uploaded_to_component)
        end

        test "Release includes component" do
          release_store = register_package.release_store

          uploaded_to_component = release_store.put? do |release|
            release.components.include?(component)
          end

          assert(uploaded_to_component)
        end
      end

      context "Omitted" do
        default_component = Defaults.component

        register_package = Commands::Package::Register.new
        register_package.distribution = Controls::Distribution.example

        register_package.(index_entry)

        test "Package index is uploaded to default component" do
          control_object_key = Controls::PackageIndex::Path.example(
            component: default_component,
            architecture: architecture
          )

          package_index_store = register_package.package_index_store

          uploaded_to_component = package_index_store.put? do |_, object_key|
            object_key == control_object_key
          end

          assert(uploaded_to_component)
        end

        test "Release includes default component" do
          release_store = register_package.release_store

          uploaded_to_component = release_store.put? do |release|
            release.components.include?(default_component)
          end

          assert(uploaded_to_component)
        end
      end
    end
  end
end
