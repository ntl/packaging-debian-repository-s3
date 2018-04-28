require_relative '../../automated_init'

context "Package Index" do
  context "Put" do
    context "Optional Architecture" do
      distribution = Controls::Distribution.example

      package_index = Controls::PackageIndex.example

      context "Given" do
        architecture = Controls::Random.unique_text

        put_package_index = PackageIndex::Put.new(distribution)
        put_package_index.(package_index, architecture: architecture)

        put_object = put_package_index.put_object

        control_object_key = Controls::PackageIndex::Path.example(
          distribution: distribution,
          architecture: architecture
        )

        test "Index is uploaded to location of given architecture" do
          assert put_object do
            put? do |object_key|
              object_key == control_object_key
            end
          end
        end
      end

      context "Omitted" do
        default_architecture = Defaults.architecture

        put_package_index = PackageIndex::Put.new(distribution)
        put_package_index.(package_index)

        put_object = put_package_index.put_object

        control_object_key = Controls::PackageIndex::Path.example(
          distribution: distribution,
          architecture: default_architecture
        )

        test "Index is uploaded to location of default architecture" do
          assert put_object do
            put? do |object_key|
              object_key == control_object_key
            end
          end
        end
      end
    end
  end
end
