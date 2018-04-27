require_relative './interactive_init'

context "GPG" do
  context "GPG Password Error" do
    comment "Note: gpg-agent must be disabled before running this test"
    comment "To disable gpg-agent, `killall gpg-agent`"

    control_text = Controls::GPG::Text.example

    sign = GPG::Sign.new
    sign.gpg_password = Controls::Random.unique_text

    test "Raises error" do
      assert proc { sign.(control_text) } do
        raises_error?(GPG::Sign::GPGError)
      end
    end
  end
end
