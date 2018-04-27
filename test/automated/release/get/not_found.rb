require_relative '../../automated_init'

context "Release" do
  context "Get" do
    context "Not Found" do
      get_release = Release::Get.new

      release = get_release.()

      test "Returns nothing" do
        assert(release.nil?)
      end
    end
  end
end
