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
                attr_accessor :get_distribution

                def self.build
                  distribution = self.distribution

                  new(distribution)
                end

                def self.distribution
                  'null'
                end

                def get(distribution: nil)
                  return nil unless distribution == get_distribution

                  get_release
                end

                def fetch(distribution: nil)
                  get(distribution: distribution) || Release.new
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

                def add(release, distribution=nil)
                  self.get_release = release
                  self.get_distribution = distribution
                end
              end
            end
          end
        end
      end
    end
  end
end
