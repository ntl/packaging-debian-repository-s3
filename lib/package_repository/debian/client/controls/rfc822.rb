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
                 Third Line

                SomeField: Other Value
                OtherField: Yet Another Value

                # Other Comment
              TEXT
            end

            module Invalid
              def self.example
                <<~TEXT
                foo=bar
                TEXT
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
          end
        end
      end
    end
  end
end
