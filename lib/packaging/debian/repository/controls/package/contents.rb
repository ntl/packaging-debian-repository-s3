module Packaging
  module Debian
    module Repository
      module Controls
        module Package
          module Contents
            def self.example
              {
                'contents.txt' => 'Example debian package'
              }
            end

            module Alternate
              def self.example
                {
                  'other-contents.txt' => 'Example debian package (Alternate)'
                }
              end
            end
          end
        end
      end
    end
  end
end
