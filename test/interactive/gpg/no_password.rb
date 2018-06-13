require_relative '../interactive_init'

context "GPG" do
  context "No Password" do
    comment "Note: gpg-agent must be disabled before running this test"
    comment "To disable gpg-agent, `killall gpg-agent`"

    comment ' '
    comment "In order to test the absence of a password, a key without"
    comment "a password must be set up"

    control_text = Controls::GPG::Text.example

    password_file = File.join('tmp', Controls::Random.unique_text)
    refute(File.exist?(password_file))

    sign = GPG::Sign.new
    sign.password_file = password_file

    test "Does not raise error" do
      refute proc { sign.(control_text) } do
        raises_error?(GPG::Sign::GPGError)
      end
    end
  end
end
