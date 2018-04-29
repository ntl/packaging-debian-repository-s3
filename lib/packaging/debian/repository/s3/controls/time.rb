module Packaging
  module Debian
    module Repository
      module S3
        module Controls
          Time = Clock::Controls::Time

          module Time
            module RFC822
              def self.example(time=nil)
                time ||= Raw.example

                time.rfc822
              end
            end
          end
        end
      end
    end
  end
end
