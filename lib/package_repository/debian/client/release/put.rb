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
          end

          def call(release)
            text = ::Transform::Write.(release, :rfc822)

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
