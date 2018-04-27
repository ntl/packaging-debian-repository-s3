require_relative '../../automated_init'

context "GPG" do
  context "Verify" do
    context "Not Verified" do
      signed_text = Controls::GPG::Text::Signed::Incorrect.example

      verify = GPG::Verify.build

      test "Error is raised" do
        assert proc { verify.(signed_text) } do
          raises_error?(GPG::Verify::GPGError)
        end
      end
    end
  end
end
