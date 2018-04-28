require_relative '../../automated_init'

context "Release" do
  context "Get" do
    context "Not Found" do
      distribution = Controls::Distribution.example

      get_release = Release::Get.new(distribution)

      release = get_release.()

      test "Returns nothing" do
        assert(release.nil?)
      end
    end
  end
end
