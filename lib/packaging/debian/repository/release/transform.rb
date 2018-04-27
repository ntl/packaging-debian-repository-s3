module Packaging
  module Debian
    module Repository
      class Release
        module Transform
          def self.rfc822_signed
            Signed
          end

          class Signed
            include Log::Dependency

            setting :gpg_password

            def configure(settings: nil, namespace: nil)
              settings ||= Settings.build
              namespace = Array(namespace)

              settings.set(self, *namespace)
            end

            def self.build(settings=nil, namespace: nil)
              instance = new
              instance.configure(settings: settings, namespace: namespace)
              instance
            end

            def self.instance
              @instance ||= build
            end

            def self.read(signed_text)
              instance.read(signed_text)
            end

            def self.write(release)
              instance.write(release)
            end

            def read(signed_text)
              gpg_command = %W(
                  gpg
                    --homedir=./keyring
                    --output -
              )

              success, text, exit_status = ShellCommand::Execute.(
                gpg_command,
                stdin: signed_text,
                logger: logger,
                include: [:stdout, :exit_status]
              )

              unless success
                error_message = "Could not verify signed release file (Exit Status: #{exit_status})"
                logger.error { error_message }
                raise GPGError, error_message
              end

              Schemas::RFC822::SingleParagraph.read(text)
            end

            def write(raw_data)
              text = Schemas::RFC822.write(raw_data)

              tmpfile = Tempfile.new('rfc822-signed')
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

              password = Settings.get(:gpg_password)

              success, signed_text, exit_status = ShellCommand::Execute.(
                gpg_command,
                logger: logger,
                stdin: password,
                include: [:stdout, :exit_status]
              )

              unless success
                error_message = "Could not sign release file (Exit Status: #{exit_status})"
                logger.error { error_message }
                raise GPGError, error_message
              end

              signed_text
            end
          end
        end
      end
    end
  end
end
