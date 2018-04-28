module Packaging
  module Debian
    module Repository
      class Release
        class Store
          module Substitute
            def self.build
              Store.new
            end

            class Store
              attr_accessor :get_release
              attr_accessor :put_release

              def get
                get_release
              end

              def fetch
                get_release || Release.new
              end

              def put(release)
                self.put_release = release
              end

              def put?(release=nil, &block)
                return false if put_release.nil?

                if release.nil?
                  if block.nil?
                    true
                  else
                    block.(put_release)
                  end
                else
                  put_release == release
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
