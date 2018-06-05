require_relative '../../automated_init'

context "Commands" do
  context "Register Package" do
    context "Optional Distribution" do
      index_entry = Controls::PackageIndex::Entry.example

      control_distribution = Controls::Distribution.example
      architecture = index_entry.architecture or fail

      context "Given" do
        distribution = Controls::Distribution::Alternate.example

        register_package = Commands::Package::Register.new
        register_package.distribution = control_distribution

        register_package.(index_entry, distribution: distribution)

        test "Package index is uploaded to given distribution" do
          control_object_key = Controls::PackageIndex::Path::Default.example(
            distribution: distribution,
            architecture: architecture
          )

          package_index_store = register_package.package_index_store

          uploaded_to_distribution = package_index_store.put? do |_, object_key|
            object_key == control_object_key
          end

          assert(uploaded_to_distribution)
        end
      end

      context "Omitted" do
        register_package = Commands::Package::Register.new
        register_package.distribution = control_distribution

        register_package.(index_entry)

        test "Package index is uploaded to distribution attribute" do
          control_object_key = Controls::PackageIndex::Path::Default.example(
            distribution: control_distribution,
            architecture: architecture
          )

          package_index_store = register_package.package_index_store

          uploaded_to_distribution = package_index_store.put? do |_, object_key|
            object_key == control_object_key
          end

          assert(uploaded_to_distribution)
        end
      end
    end
  end
end
