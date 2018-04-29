require_relative '../../../automated_init'

context "Package Index" do
  context "Put" do
    context "Optional Architecture" do
      distribution = Controls::Distribution.example

      package_index = Controls::PackageIndex.example

      context "Given" do
        architecture = Controls::Random.unique_text

        store = PackageIndex::Store.new(distribution)
        store.put(package_index, architecture: architecture)

        put_object = store.put_object

        control_object_key = Controls::PackageIndex::Path::Default.example(
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
        store = PackageIndex::Store.new(distribution)
        store.put(package_index)

        put_object = store.put_object

        control_object_key = Controls::PackageIndex::Path::Default.example

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
