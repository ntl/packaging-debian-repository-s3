module Packaging
  module Debian
    module Repository
      module Controls
        module GPG
          module Password
            def self.example
              'password'
            end
          end

          module Text
            def self.example
              <<~TEXT
              Some text
              Some text
              TEXT
            end

            module Signed
              def self.example
                text = Text.example

                Clearsign::Signature::Add.(text)
              end

              module Incorrect
                def self.example
                  text = Signed.example
                  text.gsub!(/Some text/, 'Other text')
                  text
                end
              end
            end
          end

          module Clearsign
            module Signature
              module Add
                def self.call(text)
                  gpg_password = Password.example

                  file = Tempfile.new('signed-release')
                  file.write(text)
                  file.close

                  gpg_command = %W(
                    gpg
                      --homedir=./keyring
                      --armor
                      --sign
                      --pinentry-mode loopback
                      --passphrase-fd 0
                      --output -
                      --clearsign #{file.path}
                  )

                  signed_text, _, status = Open3.capture3(
                    *gpg_command,
                    stdin_data: gpg_password
                  )

                  status.success? or fail "Could not sign release file"

                  signed_text

                ensure
                  ::File.unlink(file.path) if file
                end
              end

              module Remove
                def self.call(text)
                  gpg_command = %W(
                    gpg
                      --homedir=./keyring
                      --output -
                  )

                  unsigned_text, stderr, status = Open3.capture3(
                    *gpg_command,
                    stdin_data: text
                  )

                  status.success? or fail "Could not remove signature (Stderr: #{stderr.inspect})"

                  unsigned_text
                end
              end
            end
          end
        end
      end
    end
  end
end
