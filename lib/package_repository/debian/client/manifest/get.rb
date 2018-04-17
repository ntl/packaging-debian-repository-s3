module PackageRepository
  module Debian
    module Client
      class Manifest
        class Get
          configure :get_manifest

          setting :suite
          setting :component
          setting :architecture

          dependency :get_object, AWS::S3::Client::Object::Get

          def configure
            AWS::S3::Client::Object::Get.configure(self)
          end

          def self.build
            instance = new
            instance.configure
            instance
          end

          def call
            begin
              manifest_text = get_object.(path)
            rescue AWS::S3::Client::Object::Get::ObjectNotFound
              return nil
            end
          end

          def path
            File.join('dists', suite.to_s, component.to_s, architecture.to_s, 'Packages.gz')
          end
        end
      end
    end
  end
end
