require_relative '../../automated_init'

context "GPG" do
  context "Sign" do
    control_text = Controls::GPG::Text.example

    signed_text = GPG::Sign.(control_text)

    test "Release is converted to text and signed" do
      unsigned_text = Controls::GPG::Clearsign::Signature::Remove.(signed_text)

      assert(unsigned_text == control_text)
    end
  end
end
