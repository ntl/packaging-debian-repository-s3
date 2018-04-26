module PackageRepository
  module Debian
    module Client
      class Release
        class Put
          include Log::Dependency

          configure :put_release

          setting :suite

          dependency :put_object, AWS::S3::Client::Object::Put

          def configure
            AWS::S3::Client::Object::Put.configure(self)

            # XXX Settings
            self.suite = Controls::Suite.example
            # /XXX
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

            tmpfile = File.open('tmp/Release', 'w')
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

            password = 'password'

            signed_text, stderr, status = Open3.capture3(*gpg_command, stdin_data: password)

            File.write('tmp/InRelease', signed_text)

            object_key = path

            put_object.(object_key, text, acl: 'public-read')
          end

          def path
            File.join('dists', suite.to_s, 'InRelease')
          end
        end
      end
    end
  end
end
