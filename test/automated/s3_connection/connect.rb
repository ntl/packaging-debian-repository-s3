require_relative '../automated_init'

context "S3 Connection" do
  context "Connect" do
    context do
      s3_connection = S3Connection.build

      return_value = s3_connection.connect

      test "Returns S3 client" do
        assert(return_value.instance_of?(Aws::S3::Client))
      end
    end

    context "Unauthorized" do
      context "Non-existent Access Key" do
        s3_connection = S3Connection.build
        s3_connection.access_key_id = SecureRandom.hex(7).upcase

        test "Error is raised" do
          assert proc { s3_connection.connect } do
            raises_error?(S3Connection::Unauthorized)
          end
        end
      end

      context "Incorrect Secret" do
        s3_connection = S3Connection.build
        s3_connection.secret_access_key = 'incorrect'

        test "Error is raised" do
          assert proc { s3_connection.connect } do
            raises_error?(S3Connection::Unauthorized)
          end
        end
      end
    end

    context "Bucket Does Not Exist" do
      s3_connection = S3Connection.build
      s3_connection.bucket = "some-bucket-#{SecureRandom.hex(7)}"

      test "Error is raised" do
        assert proc { s3_connection.connect } do
          raises_error?(S3Connection::BucketNotFound)
        end
      end
    end
  end
end
