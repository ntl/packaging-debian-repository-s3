require_relative '../automated_init'

context "RFC822" do
  context "Read" do
    context do
      text = Controls::RFC822::Text.example

      read_data = RFC822.read(text)

      test "Converts to raw data" do
        control_data = Controls::RFC822::Data.example

        assert(read_data == control_data)
      end
    end

    context "Malformed Text" do
      text = Controls::RFC822::Text::Invalid.example

      test "Raises error" do
        assert proc { RFC822.read(text) } do
          raises_error?(RFC822::ParseError)
        end
      end
    end
  end
end
