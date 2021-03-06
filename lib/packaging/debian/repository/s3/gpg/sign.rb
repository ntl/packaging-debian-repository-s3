module Packaging
  module Debian
    module Repository
      module S3
        module GPG
          class Sign
            include Log::Dependency

            attr_writer :password_file
            def password_file
              @password_file ||= File.join('settings', 'gpg_password.txt')
            end

            def self.call(text)
              instance = new
              instance.(text)
            end

            def call(text)
              if File.size?(password_file)
                passphrase_argument = "--passphrase-file #{password_file}"
              end

              gpg_command = <<~SH.gsub(%r{[[:space:]]+}, ' ')
              gpg
                --homedir=./keyring
                --armor
                --batch
                --sign
                --pinentry-mode loopback
                #{passphrase_argument}
                --output -
                --clearsign
              SH

              success, signed_text, exit_status = ShellCommand::Execute.(
                gpg_command,
                logger: logger,
                stdin: text,
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
end
