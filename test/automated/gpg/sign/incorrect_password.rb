require_relative '../../automated_init'

context "GPG" do
  context "Sign" do
    context "Incorrect Password" do
      comment "Note: gpg-agent must be disabled before running this test"
      comment "As a result, this test must be interactive. See test/interactive/gpg/incorrect_password.rb"
    end
  end
end
