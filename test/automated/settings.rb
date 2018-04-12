require_relative './automated_init'

context "Settings" do
  module Fixtures
    class Example
      setting :access_key_id
      setting :secret_access_key
      setting :bucket
      setting :region
    end
  end

  receiver = Fixtures::Example.new

  PackageRepository::Debian::Client::Settings.set(receiver)

  test "Access Key ID" do
    refute(receiver.access_key_id.nil?)
  end

  test "Secret Access Key" do
    refute(receiver.secret_access_key.nil?)
  end

  test "Bucket" do
    refute(receiver.bucket.nil?)
  end

  test "Region" do
    refute(receiver.region.nil?)
  end
end
