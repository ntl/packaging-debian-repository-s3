module Packaging
  module Debian
    module Repository
      module GPG
        class Sign
          include Log::Dependency

          setting :gpg_password

          def configure(settings: nil, namespace: nil)
            settings ||= Settings.build
            namespace = Array(namespace)

            settings.set(self, *namespace)
          end

          def self.build(settings: nil, namespace: nil)
            instance = new
            instance.configure(settings: settings, namespace: namespace)
            instance
          end

          def self.call(text, settings: nil, namespace: nil)
            instance = build(settings: settings, namespace: namespace)
            instance.(text)
          end

          def call(text)
            tmpfile = Tempfile.new('gpg-clearsign-input')
            tmpfile.write(text)
            tmpfile.close

            gpg_command = %W(
              gpg
                --homedir=./keyring
                --armor
                --batch
                --sign
                --pinentry-mode loopback
                --passphrase-fd 0
                --output -
                --clearsign #{tmpfile.path}
            )

            stdin = "#{gpg_password}\n"

            success, signed_text, exit_status = ShellCommand::Execute.(
              gpg_command,
              logger: logger,
              stdin: stdin,
              include: [:stdout, :exit_status]
            )

            unless success
              error_message = "Could not sign file (Exit Status: #{exit_status})"
              logger.error { error_message }
              raise GPGError, error_message
            end

            signed_text
          end

          GPGError = Class.new(StandardError)
        end
      end
    end
  end
end
