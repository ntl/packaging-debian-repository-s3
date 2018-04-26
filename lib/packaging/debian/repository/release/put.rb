module Packaging
  module Debian
    module Repository
      class Release
        class Put
          include Log::Dependency

          configure :put_release

          setting :suite
          setting :gpg_password

          dependency :put_object, AWS::S3::Client::Object::Put

          def configure(settings: nil, namespace: nil)
            settings ||= Settings.build
            namespace = Array(namespace)

            settings.configure(self, *namespace)

            AWS::S3::Client::Object::Put.configure(self)
          end

          def self.build
            instance = new
            instance.configure
            instance
          end

          def self.call(release)
            instance = build
            instance.(release)
          end

          def call(release)
            text = ::Transform::Write.(release, :rfc822)

            infile = Tempfile.new('packaging-repository-sign-release-in')
            infile.write(text)
            infile.close

            outfile = Tempfile.new('packaging-repository-sign-release-out')

            outfile_path = outfile.path

            outfile.close
            outfile.unlink

            gpg_command = %W(
              gpg
                --homedir=./keyring
                --armor
                --sign
                --pinentry-mode loopback
                --passphrase-fd 0
                --output #{outfile_path}
                --clearsign #{infile.path}
            )

            stdin = StringIO.new("#{gpg_password}\n")

            ShellCommand::Execute.(
              gpg_command,
              stdin: stdin,
              logger: logger
            )

            signed_text = ::File.read(outfile_path)

            ::File.write('tmp/InRelease', signed_text)

            object_key = path

            put_object.(object_key, signed_text, acl: 'public-read')

          ensure
            ::File.unlink(infile.path)
          end

          def path
            ::File.join('dists', suite.to_s, 'InRelease')
          end
        end
      end
    end
  end
end
