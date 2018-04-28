module Packaging
  module Debian
    module Repository
      module S3
        module GPG
          class Verify
            include Log::Dependency

            def self.build
              instance = new
              instance
            end

            def self.call(signed_text)
              instance = build
              instance.(signed_text)
            end

            def call(signed_text)
              gpg_command = %W(
              gpg
                --homedir=./keyring
                --output -
              )

              success, text, exit_status = ShellCommand::Execute.(
                gpg_command,
                logger: logger,
                stdin: signed_text,
                include: [:stdout, :exit_status]
              )

              unless success
                error_message = "Could not verify clearsigned text (Exit Status: #{exit_status})"
                logger.error { error_message }
                raise GPGError, error_message
              end

              text
            end

            GPGError = Class.new(StandardError)
          end
        end
      end
    end
  end
end
