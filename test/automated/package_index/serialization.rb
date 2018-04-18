require_relative '../automated_init'

context "Package Index" do
  context "Serialization" do
    control_text = Controls::Package::Index.text
    control_index = Controls::Package::Index.example

    test "Deserialize" do
      package_index = Transform::Read.(control_text, :rfc822, Package::Index)

      assert(package_index == control_index)
    end

    test "Serialize" do
      package_index_text = Transform::Write.(control_index, :rfc822)

      assert(package_index_text == control_text)
    end
  end
end
