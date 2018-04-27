module Packaging
  module Debian
    module Repository
      class Release
        class Get
          include Log::Dependency

          configure :get_release

          setting :suite

          dependency :get_object, AWS::S3::Client::Object::Get

          def configure(settings: nil, namespace: nil)
            settings ||= Settings.build
            namespace = Array(namespace)

            settings.set(self, *namespace)

            AWS::S3::Client::Object::Get.configure(self)
          end

          def self.build(settings: nil, namespace: nil)
            instance = new
            instance.configure(settings: settings, namespace: namespace)
            instance
          end

          def self.call(settings: nil, namespace: nil)
            instance.build(settings: settings, namespace: namespace)
            instance.call
          end

          def call
            begin
              data_source = get_object.(path)
            rescue AWS::S3::Client::Object::Get::ObjectNotFound
              return nil
            end

            text = String.new

            text << data_source.read until data_source.eof?

            ::Transform::Read.(text, :rfc822_signed, Release)
          end

          def path
            ::File.join('dists', suite.to_s, 'InRelease')
          end
        end
      end
    end
  end
end
