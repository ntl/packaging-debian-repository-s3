require_relative '../automated_init'

context "Get Manifest" do
  context "Not Found" do
    get_manifest = Manifest::Get.new

    get_manifest.()

    manifest = get_manifest.()

    test "Returns nil" do
      assert(manifest.nil?)
    end
  end
end
