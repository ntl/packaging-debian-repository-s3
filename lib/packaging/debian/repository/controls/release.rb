module Packaging
  module Debian
    module Repository
      module Controls
        Release = Packaging::Debian::Schemas::Controls::Release

        module Release
          module Text
            module Signed
              def self.example
                unsigned_text = Text.example

                GPG::Clearsign::Signature::Add.(unsigned_text)
              end
            end
          end

          module Path
            def self.example
              "dists/#{distribution}/InRelease"
            end

            def self.distribution
              Distribution.example
            end
          end
        end
      end
    end
  end
end
