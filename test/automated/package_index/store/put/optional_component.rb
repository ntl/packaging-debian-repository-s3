require_relative '../../../automated_init'

context "Package Index" do
  context "Put" do
    context "Optional Component" do
      distribution = Controls::Distribution.example

      package_index = Controls::PackageIndex.example

      context "Given" do
        component = Controls::Random.unique_text

        store = PackageIndex::Store.new(distribution)
        store.put(package_index, component: component)

        put_object = store.put_object

        control_object_key = Controls::PackageIndex::Path::Default.example(
          component: component
        )

        test "Index is uploaded to location of given component" do
          assert put_object do
            put? do |object_key|
              object_key == control_object_key
            end
          end
        end
      end

      context "Omitted" do
        default_copmonent = Defaults.component

        store = PackageIndex::Store.new(distribution)
        store.put(package_index)

        put_object = store.put_object

        control_object_key = Controls::PackageIndex::Path::Default.example

        test "Index is uploaded to location of default component" do
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
