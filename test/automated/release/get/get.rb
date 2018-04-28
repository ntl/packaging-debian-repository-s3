require_relative '../../automated_init'

context "Release" do
  context "Get" do
    get_release = Release::Get.new

    get_release.distribution = Controls::Distribution.example

    release_path = Controls::Release::Path.example

    signed_text = Controls::Release::Text::Signed.example
    data_source = StringIO.new(signed_text)

    get_object = get_release.get_object
    get_object.add(release_path, data_source)

    release = get_release.()

    test "Returns release" do
      assert(release == Controls::Release.example)
    end
  end
end
