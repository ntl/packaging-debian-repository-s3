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

            AWS::S3::Client::Object::Put.configure(self)

            settings.configure(self, *namespace)
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

            tmpfile = Tempfile.new('packaging-repository-sign-release')
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

            signed_text, stderr, status = Open3.capture3(
              *gpg_command,
              stdin_data: gpg_password
            )

            ::File.write('tmp/InRelease', signed_text)

            object_key = path

            put_object.(object_key, signed_text, acl: 'public-read')

          ensure
            ::File.unlink(tmpfile)
          end

          def path
            ::File.join('dists', suite.to_s, 'InRelease')
          end
        end
      end
    end
  end
end
