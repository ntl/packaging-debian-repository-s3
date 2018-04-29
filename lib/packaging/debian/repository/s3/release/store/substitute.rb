module Packaging
  module Debian
    module Repository
      module S3
        class Release
          class Store
            module Substitute
              def self.build
                Store.build
              end

              class Store < Store
                attr_accessor :get_release

                def self.build
                  distribution = self.distribution

                  new(distribution)
                end

                def self.distribution
                  'null'
                end

                def get
                  get_release
                end

                def fetch
                  get_release || Release.new
                end

                def put?(release=nil, &block)
                  if release.nil?
                    block ||= proc { true }
                  else
                    block ||= proc { |put_release| put_release == release }
                  end

                  put_object.put? do |object_key, telemetry_data|
                    put_text = telemetry_data.data_source.string

                    put_release = ::Transform::Read.(put_text, :rfc822_signed, Release)

                    block.(put_release, object_key)
                  end
                end

                def add(release)
                  self.get_release = release
                end
              end
            end
          end
        end
      end
    end
  end
end
