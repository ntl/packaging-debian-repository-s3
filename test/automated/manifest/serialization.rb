require_relative '../automated_init'

context "Manifest" do
  context "Serialization" do
    control_manifest_text = Controls::Manifest::Text.example

    context "Deserialize" do
      packages = Transform::Read.(control_manifest_text, :rfc822, Manifest)

      test "Packages" do
        assert(packages == Controls::Manifest::Packages.example)
      end
    end

    context "Serialize" do
      manifest = Controls::Manifest.example

      manifest_text = Transform::Write.(manifest, :rfc822)

      test "Packages" do
        assert(manifest_text == control_manifest_text)
      end
    end
  end
end
