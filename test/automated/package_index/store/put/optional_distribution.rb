require_relative '../../../automated_init'

context "Package Index" do
  context "Put" do
    context "Optional Distribution" do
      distribution = Controls::Distribution.example

      package_index = Controls::PackageIndex.example

      context "Given" do
        override_distribution = Controls::Random.unique_text

        store = PackageIndex::Store.new(distribution)
        store.put(package_index, distribution: override_distribution)

        put_object = store.put_object

        control_object_key = Controls::PackageIndex::Path.example(
          distribution: override_distribution
        )

        test "Index is uploaded to location of given distribution" do
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

        control_object_key = Controls::PackageIndex::Path.example(
          distribution: distribution
        )

        test "Index is uploaded to location of distribution" do
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
