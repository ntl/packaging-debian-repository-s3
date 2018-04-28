require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Substitute" do
      context "Get" do
        context "Release Added" do
          control_release = Controls::Release.example

          substitute = Dependency::Substitute.build(Release::Store)

          substitute.add(control_release)

          release = substitute.get

          test "Returns release that was added" do
            assert(release == control_release)
          end
        end

        context "Release Not Added" do
          substitute = Dependency::Substitute.build(Release::Store)

          release = substitute.get

          test "Returns nothing" do
            assert(release.nil?)
          end
        end
      end
    end
  end
end
