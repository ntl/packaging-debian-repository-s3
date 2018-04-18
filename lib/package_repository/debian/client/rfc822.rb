module PackageRepository
  module Debian
    module Client
      module RFC822
        def self.read(text)
          paragraphs = []

          index = 0

          text = text.dup

          until text.empty?
            next if text.slice!(Patterns.comment)

            if text.slice!(Patterns.blank_line)
              index += 1
              next
            end

            match_data = Patterns.field.match(text)

            if match_data.nil?
              raise ParseError, "Malformed text"
            end

            text.slice!(match_data.to_s)

            field = match_data[:field]
            raw_value = match_data[:value]

            value = String.new

            raw_value.each_line do |line|
              line.strip!

              value.concat(line.strip)
              value.concat("\n")
            end

            value.chomp!

            paragraphs[index] ||= {}

            current_paragraph = paragraphs[index]

            underscore_field = Casing::Underscore.(field)

            current_paragraph[underscore_field.to_sym] = value
          end

          paragraphs
        end

        def self.write(data)
          data = [data] if data.instance_of?(Hash)

          text = String.new

          data.each_with_index do |paragraph_data, index|
            text << "\n" unless index.zero?

            paragraph_data.each do |field, value|
              value = String(value)

              next if value.empty?

              field = Casing::Pascal.(field.to_s)

              text << "#{field}: "

              value.each_line.with_index do |line, index|
                text << "\n " unless index.zero?

                text << line.chomp
              end

              text << "\n"
            end
          end

          text
        end

        ParseError = Class.new(StandardError)

        module Patterns
          def self.comment
            %r{\A\#.*[\r\n]}
          end

          def self.blank_line
            %r{\A[[:blank:]]*[\r\n]}
          end

          def self.field
            field_name = %r{(?<field>[[:graph:]]*?)}

            inline_value = %r{.*\n}

            multiline_text = %r{(?:[[:blank:]]+.*\n)}

            %r{
              (?<field>#{field_name})  # SomeField
              :[[:blank:]]*            #          :
              (?<value>                #
                    #{inline_value}        #            some data\n
                    #{multiline_text}*     #                         foo\n  bar
              )
            }x
          end
        end
      end
    end
  end
end
