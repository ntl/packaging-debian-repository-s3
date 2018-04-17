require_relative '../automated_init'

context "Get Manifest" do
  get_manifest = Manifest::Get.new

  get_manifest.suite = suite = Controls::Suite.example
  get_manifest.component = component = Controls::Component.example
  get_manifest.architecture = architecture = Controls::Architecture.example

  manifest_path = Controls::Manifest::Path.example

  manifest_text = Controls::Manifest::Text.example

  get_object = get_manifest.get_object

  get_object.add(
    "dists/#{suite}/#{component}/#{architecture}/Packages.gz",
    manifest_text
  )

  get_manifest.()

  break # XXX finish

  manifest = get_manifest.()

  test "Returns manifest" do
    assert(manifest.instance_of?(Manifest))
  end

  context "Attributes" do
    test "Suite" do
      assert(manifest.suite == suite)
    end

    test "Component" do
      assert(manifest.component == component)
    end

    test "Architecture" do
      assert(manifest.architecture == architecture)
    end
  end

  test "Packages" do
    packages = manifest.packages

    assert(packages == Controls::Manifest::Packages.example)
  end
end
