require_relative '../interactive_init'

context "GPG" do
  context "Incorrect Password" do
    comment "Note: gpg-agent must be disabled before running this test"
    comment "To disable gpg-agent, `killall gpg-agent`"

    control_text = Controls::GPG::Text.example

    gpg_password = Controls::Random.unique_text

    password_file = Tempfile.new
    password_file.write(gpg_password)
    password_file.close

    sign = GPG::Sign.new
    sign.password_file = password_file.path

    test "Raises error" do
      assert proc { sign.(control_text) } do
        raises_error?(GPG::Sign::GPGError)
      end
    end

  ensure
    password_file.unlink
  end
end
