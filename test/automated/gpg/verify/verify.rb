require_relative '../../automated_init'

context "GPG" do
  context "Verify" do
    signed_text = Controls::GPG::Text::Signed.example

    text = GPG::Verify.(signed_text)

    test "Raw text is returned" do
      assert(text == Controls::GPG::Text.example)
    end
  end
end
