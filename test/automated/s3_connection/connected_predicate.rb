require_relative '../automated_init'

context "S3 Connection" do
  context "Connected Predicate" do
    context "Connected" do
      s3_connection = S3Connection.build

      s3_connection.connect

      test "Returns true" do
        assert(s3_connection.connected?)
      end
    end

    context "Not Yet Connected" do
      s3_connection = S3Connection.build

      test "Returns false" do
        refute(s3_connection.connected?)
      end
    end
  end
end
