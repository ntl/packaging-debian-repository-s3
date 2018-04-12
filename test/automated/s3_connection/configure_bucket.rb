require_relative '../automated_init'

context "S3 Connection" do
  context "Configure Bucket" do
    context "Attribute Name Not Given" do
      receiver = OpenStruct.new

      S3Connection.configure_bucket(receiver)

      context "S3 Bucket Attribute On Receiver" do
        attribute = receiver.s3_bucket

        test "Is S3 bucket instance" do
          assert(attribute.instance_of?(Aws::S3::Bucket))
        end
      end
    end

    context "Attribute Name Given" do
      receiver = OpenStruct.new

      S3Connection.configure_bucket(receiver, attr_name: :some_attribute)

      context "Attribute On Receiver" do
        attribute = receiver.some_attribute

        test "Is S3 bucket instance" do
          assert(attribute.instance_of?(Aws::S3::Bucket))
        end
      end

      context "S3 Bucket Attribute On Receiver" do
        test "Not set" do
          assert(receiver.s3_bucket.nil?)
        end
      end
    end
  end
end
