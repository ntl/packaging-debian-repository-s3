require_relative '../../automated_init'

context "Release" do
  context "Put" do
    release = Controls::Release.example

    put_release = Release::Put.new
    put_release.gpg_password = Controls::GPG::Password.example

    put_release.suite = suite = Controls::Suite.example

    release_path = Controls::Release::Path.example

    put_object = put_release.put_object

    put_release.(release)

    test "Release is uploaded to repository" do
      control_text = Controls::Release::Text.example
      control_path = Controls::Release::Path.example

      assert put_object do
        put? do |object_key, data|
          unsigned_data = Controls::GPG::Clearsign::Signature::Remove.(data.data_source.string)

          object_key == control_path && unsigned_data == control_text
        end
      end
    end

    test "ACL is set to public read" do
      assert put_object do
        put? do |_, data|
          data.acl == 'public-read'
        end
      end
    end
  end
end
