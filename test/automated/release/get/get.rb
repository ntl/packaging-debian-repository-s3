require_relative '../../automated_init'

context "Release" do
  context "Get" do
    distribution = Controls::Distribution.example

    get_release = Release::Get.new(distribution)

    release_path = Controls::Release::Path.example(distribution)

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
