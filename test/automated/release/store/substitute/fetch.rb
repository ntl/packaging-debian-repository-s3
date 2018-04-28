require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Substitute" do
      context "Fetch" do
        context "Release Added" do
          control_release = Controls::Release.example

          substitute = Dependency::Substitute.build(Release::Store)

          substitute.add(control_release)

          release = substitute.fetch

          test "Returns release that was added" do
            assert(release == control_release)
          end
        end

        context "Release Not Added" do
          substitute = Dependency::Substitute.build(Release::Store)

          release = substitute.fetch

          test "Returns uninitialized release" do
            assert(release == Release.new)
          end
        end
      end
    end
  end
end
