require_relative '../../automated_init'

context "Package Index" do
  context "Get" do
    context "Optional Architecture" do
      distribution = Controls::Distribution.example

      compressed_text = Controls::PackageIndex::Text::GZip.example

      context "Given" do
        architecture = Controls::Random.unique_text

        get_package_index = PackageIndex::Get.new(distribution)
        get_package_index.architecture = architecture

        package_index_path = Controls::PackageIndex::Path.example(
          distribution: distribution,
          architecture: architecture
        )

        data_source = StringIO.new(compressed_text)

        get_object = get_package_index.get_object
        get_object.add(package_index_path, data_source)

        package_index = get_package_index.(architecture: architecture)

        test "Retrieves index for given architecture" do
          refute(package_index.nil?)
        end
      end

      context "Omitted" do
        default_architecture = Defaults.architecture

        get_package_index = PackageIndex::Get.new(distribution)

        package_index_path = Controls::PackageIndex::Path.example(
          distribution: distribution,
          architecture: default_architecture
        )

        data_source = StringIO.new(compressed_text)

        get_object = get_package_index.get_object
        get_object.add(package_index_path, data_source)

        package_index = get_package_index.()

        test "Retrieves index for default architecture" do
          refute(package_index.nil?)
        end
      end
    end
  end
end
