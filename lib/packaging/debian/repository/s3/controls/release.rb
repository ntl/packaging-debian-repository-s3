module Packaging
  module Debian
    module Repository
      module S3
        module Controls
          Release = Packaging::Debian::Schemas::Controls::Release

          module Release
            module Text
              module Signed
                def self.example
                  unsigned_text = Text.example

                  GPG::Clearsign::Signature::Add.(unsigned_text)
                end

                def self.stream
                  StringIO.new(example)
                end
              end
            end

            module Path
              def self.example(distribution=nil)
                distribution ||= Distribution.example

                "dists/#{distribution}/InRelease"
              end
            end
          end
        end
      end
    end
  end
end