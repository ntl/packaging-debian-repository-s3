module Packaging
  module Debian
    module Repository
      module S3
        module Commands
          module Package
            class Publish
              module Substitute
                def self.build
                  Publish.new
                end

                class Publish
                  def call(deb_file, distribution: nil, component: nil)
                    record = Record.new(deb_file, distribution, component)

                    records << record

                    record
                  end

                  def published?(deb_file=nil, &block)
                    block ||= proc { |file| deb_file.nil? || file == deb_file }

                    records.any? do |record|
                      block.(record.deb_file, record.distribution, record.component)
                    end
                  end

                  def records
                    @records ||= []
                  end

                  Record = Struct.new(:deb_file, :distribution, :component)
                end
              end
            end
          end
        end
      end
    end
  end
end
