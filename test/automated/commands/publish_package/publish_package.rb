require_relative '../../automated_init'

context "Commands" do
  context "Publish Package" do
    deb_file = Controls::Package::File.example

    distribution = Controls::Distribution.example
    component = Controls::Component.example

    publish_package = Commands::Package::Publish.new(distribution)

    index_entry = publish_package.(deb_file, component: component)

    context "Package File Upload" do
      test "Package file is uploaded to pool" do
        control_object_key = Controls::Package::Path.example(deb_file)

        uploaded_to_pool = publish_package.put_object.put? do |object_key|
          object_key == control_object_key
        end

        assert(uploaded_to_pool)
      end

      test "Uploaded data" do
        uploaded_data = publish_package.put_object.put? do |_, data|
          data.data_source.path == deb_file
        end

        assert(uploaded_data)
      end
    end

    context "Package Index Entry" do
      test "Is returned" do
        assert(index_entry.instance_of?(PackageIndex::Entry))
      end

      test "Is registered" do
        registered = publish_package.register_package.registered? do |entry, comp|
          entry == index_entry && comp == component
        end

        assert(registered)
      end

      context "Index Entry Attributes" do
        context "Filename" do
          assert(index_entry.filename == Controls::Package::File.basename)
        end

        context "Size" do
          assert(index_entry.size == Controls::Package::File.size)
        end

        context "SHA256" do
          assert(index_entry.sha256 == Controls::Package::File.sha256)
        end
      end

      context "Package Control Attributes" do
        control_package = Controls::Package.example

        control_package.attributes.each do |attribute, control_value|
          test "#{attribute}" do
            value = index_entry.public_send(attribute)

            comment "Value: #{value.inspect}"
            comment "Control Value: #{control_value.inspect}"

            assert(value == control_value)
          end
        end
      end
    end
  end
end
