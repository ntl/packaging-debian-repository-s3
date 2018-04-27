require_relative '../automated_init'

context "Release" do
  context "Serialization" do
    control_release = Controls::Release.example

    control_signed_text = Controls::Release::Text::Signed.example

    context "Read" do
      release = Transform::Read.(control_signed_text, :rfc822_signed, Release)

      test do
        assert(release == control_release)
      end
    end

    context "Write" do
      signed_text = Transform::Write.(control_release, :rfc822_signed)

      test do
        control_text = Controls::GPG::Clearsign::Signature::Remove.(control_signed_text)
        text = Controls::GPG::Clearsign::Signature::Remove.(signed_text)

        assert(text == control_text)
      end
    end
  end
end
