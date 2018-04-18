module PackageRepository
  module Debian
    module Client
      module Controls
        module RFC822
          module Text
            def self.example
              <<~TEXT
                # Some Comment
                SomeField: Some Value
                OtherField: First Line
                    Second Line
                \tThird Line

                SomeField: Other Value
                OtherField: Yet Another Value

                # Other Comment
              TEXT
            end

            module Canonical
              def self.example
                <<~TEXT
                  SomeField: Some Value
                  OtherField: First Line
                   Second Line
                   Third Line

                  SomeField: Other Value
                  OtherField: Yet Another Value
                TEXT
              end
            end

            module Invalid
              def self.example
                <<~TEXT
                foo=bar
                TEXT
              end
            end

            module SingleParagraph
              def self.example
                <<~TEXT
                  # Some Comment
                  SomeField: Some Value
                  OtherField: First Line
                      Second Line
                  \tThird Line
                TEXT
              end

              module Canonical
                def self.example
                  <<~TEXT
                    SomeField: Some Value
                    OtherField: First Line
                     Second Line
                     Third Line
                  TEXT
                end
              end
            end
          end

          module Data
            def self.example
              [
                {
                  :some_field => 'Some Value',
                  :other_field => "First Line\nSecond Line\nThird Line",
                },
                {
                  :some_field => 'Other Value',
                  :other_field => 'Yet Another Value'
                }
              ]
            end

            module SingleParagraph
              def self.example
                {
                  :some_field => 'Some Value',
                  :other_field => "First Line\nSecond Line\nThird Line",
                }
              end
            end
          end
        end
      end
    end
  end
end
