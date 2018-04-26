module Packaging
  module Debian
    module Repository
      module Controls
        Release = Packaging::Debian::Schemas::Controls::Release

        module Release
          module Path
            def self.example
              "dists/#{distribution}/InRelease"
            end

            def self.distribution
              Distribution.example
            end
          end

          module Text
            module Signed
              def self.example
                text = Text.example

                tmpfile = Tempfile.new('signed-release')

                tmpfile.write(text)

                tmpfile.close

                gpg_command = %W(
                  gpg
                    --homedir=./keyring
                    --armor
                    --sign
                    --pinentry-mode loopback
                    --passphrase-fd 0
                    --output -
                    --clearsign #{tmpfile.path}
                )

                signed_text, status = Open3.capture2e(
                  *gpg_command,
                  stdin_data: password
                )

                status.success? or fail "Could not sign release file"

                File.unlink(tmpfile.path)

                signed_text
              end

              def self.password
                'password'
              end
            end
          end
        end
      end
    end
  end
end
