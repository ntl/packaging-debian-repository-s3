require_relative '../automated_init'

context "Package Index" do
  context "Serialization" do
    control_index = Controls::PackageIndex.example

    control_compressed_text = Controls::PackageIndex::Text::Compressed.example

    context "Read" do
      package_index = Transform::Read.(control_compressed_text, :rfc822_compressed, PackageIndex)

      test do
        assert(package_index == control_index)
      end
    end

    context "Write" do
      compressed_text = Transform::Write.(control_index, :rfc822_compressed)

      test do
        assert(compressed_text == control_compressed_text)
      end
    end
  end
end
