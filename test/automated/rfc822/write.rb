require_relative '../automated_init'

context "RFC822" do
  context "Write" do
    context do
      data = Controls::RFC822::Data.example

      text = RFC822.write(data)

      test "Converts to raw data" do
        control_text = Controls::RFC822::Text::Canonical.example

        assert(text == control_text)
      end
    end

    context "Non-string field value" do
      data = {
        :some_field => 111,
      }

      text = RFC822.write(data)

      test "Is converted to string" do
        assert(text == <<~TEXT)
        SomeField: 111
        TEXT
      end
    end

    context "Missing field value" do
      data = {
        :missing_field => nil,
        :present_field => 'Some value',
        :blank_field => ''
      }

      text = RFC822.write(data)

      test "Is omitted" do
        assert(text == <<~TEXT)
          PresentField: Some value
        TEXT
      end
    end

    context "Single Paragraph" do
      data = Controls::RFC822::Data::SingleParagraph.example

      text = RFC822.write(data)

      test "Converts to raw data" do
        control_text = Controls::RFC822::Text::SingleParagraph::Canonical.example

        assert(text == control_text)
      end
    end
  end
end
