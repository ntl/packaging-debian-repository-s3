require_relative '../../automated_init'

context "GPG" do
  context "Sign" do
    context "Password Error" do
      comment "Note: gpg-agent must be disabled before running this test"
      comment "As a result, this test must be interactive. See test/interactive/gpg_password_error.rb"
    end
  end
end
