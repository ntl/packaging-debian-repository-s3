module PackageRepository
  module Debian
    module Client
      class Package
        class Index
          include Schema::DataStructure

          attribute :entries, Array, default: proc { [] }

          def add(package)
            entries << package
          end

          class Package
            include Schema::DataStructure

            attribute :filename, String
            attribute :size, Integer
            attribute :md5sum, String
            attribute :sha1, String
            attribute :sha256, String
            attribute :sha512, String
            attribute :description_md5, String

            include Client::Package::Attributes
          end

          module Transform
            def self.rfc822
              RFC822
            end

            def self.instance(raw_data)
              paragraphs = raw_data

              index = Index.new

              paragraphs.each do |paragraph|
                package_data = {
                  :filename => paragraph.fetch(:filename),
                  :size => paragraph.fetch(:size).to_i
                }

                [:md5sum, :sha1, :sha256, :sha512, :description_md5].each do |attribute|
                  next unless paragraph.key?(attribute)

                  package_data[attribute] = paragraph[attribute]
                end

                Client::Package.attribute_names.each do |attribute|
                  next unless paragraph.key?(attribute)

                  value = paragraph[attribute]

                  if attribute == :installed_size
                    value = value.to_i
                  elsif attribute == :essential
                    value = value == 'yes' ? true : false
                  end

                  package_data[attribute] = value
                end

                package = Package.build(package_data)

                index.add(package)
              end

              index
            end
          end
        end
      end
    end
  end
end
