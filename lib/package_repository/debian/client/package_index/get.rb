module PackageRepository
  module Debian
    module Client
      class PackageIndex
        class Get
          include Log::Dependency

          configure :get_package_index

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
              package_index_text = get_object.(path)
            rescue AWS::S3::Client::Object::Get::ObjectNotFound
              return nil
            end

            ::Transform::Read.(package_index_text, :rfc822, PackageIndex)
          end

          def path
            File.join('dists', suite.to_s, component.to_s, architecture.to_s, 'Packages.gz')
          end
        end
      end
    end
  end
end
