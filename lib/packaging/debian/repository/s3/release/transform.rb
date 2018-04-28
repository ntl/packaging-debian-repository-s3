module Packaging
  module Debian
    module Repository
      module S3
        class Release
          module Transform
            def self.rfc822_signed
              RFC822Signed
            end

            module RFC822Signed
              def self.read(signed_text)
                text = GPG::Verify.(signed_text)

                Schemas::RFC822::SingleParagraph.read(text)
              end

              def self.write(raw_data)
                text = Schemas::RFC822.write(raw_data)

                GPG::Sign.(text)
              end
            end
          end
        end
      end
    end
  end
end
