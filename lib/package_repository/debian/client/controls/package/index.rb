module PackageRepository
  module Debian
    module Client
      module Controls
        module Package
          module Index
            def self.example
              package_index = Client::Package::Index.new
              package_index.add(Entry.example)
              package_index.add(Entry::Alternate.example)
              package_index
            end

            def self.data
              [
                Entry.data,
                Entry::Alternate.data
              ]
            end

            def self.text
              <<~TEXT
              #{Entry.text.chomp}

              #{Entry::Alternate.text.chomp}
              TEXT
            end
          end
        end
      end
    end
  end
end
