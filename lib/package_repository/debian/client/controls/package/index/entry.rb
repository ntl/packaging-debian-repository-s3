module PackageRepository
  module Debian
    module Client
      module Controls
        module Package
          module Index
            module Entry
              def self.example(**arguments)
                data = self.data(**arguments)

                Client::Package::Index::Package.build(data)
              end

              def self.data(filename: nil, size: nil, md5sum: nil, sha1: nil, sha256: nil, sha512: nil, description_md5sum: nil, **package_attributes)
                filename ||= self.filename
                size ||= self.size
                md5sum ||= self.md5sum
                sha1 ||= self.sha1
                sha256 ||= self.sha256
                sha512 ||= self.sha512
                description_md5sum ||= self.description_md5sum

                data = {}

                %i[filename size md5sum sha1 sha256 sha512 description_md5sum].each do |attribute|
                  value = binding.local_variable_get(attribute)

                  next if value == :none

                  data[attribute] = value
                end

                package_data = Package.data(**package_attributes)

                data.merge!(package_data)

                data
              end

              def self.text
                package_control_text = Control.text
                package_control_text.chomp!

                <<~TEXT
                  Filename: #{filename}
                  Size: #{size}
                  MD5sum: #{md5sum}
                  SHA1: #{sha1}
                  SHA256: #{sha256}
                  SHA512: #{sha512}
                  Description-md5sum: #{description_md5sum}
                  #{package_control_text}
                TEXT
              end

              def self.filename
                File.name
              end

              def self.size
                111
              end

              def self.md5sum
                Digest::MD5.hexdigest('some-md5sum')
              end

              def self.sha1
                Digest::SHA1.hexdigest('some-sha1')
              end

              def self.sha256
                Digest::SHA256.hexdigest('some-sha256')
              end

              def self.sha512
                Digest::SHA512.hexdigest('some-sha512')
              end

              def self.description_md5sum
                Digest::MD5.hexdigest("#{Attributes.description}\n")
              end

              module Alternate
                def self.example
                  Client::Package::Index::Package.build(data)
                end

                def self.data
                  Entry.data(
                    filename: Package::File::Alternate.name,
                    size: size,
                    md5sum: md5sum,
                    sha1: sha1,
                    sha256: sha256,
                    sha512: sha512,
                    description_md5sum: description_md5sum,
                    default_source: Attributes::Alternate
                  )
                end

                def self.filename
                  File::Alternate.name
                end

                def self.size
                  222
                end

                def self.md5sum
                  Digest::MD5.hexdigest('other-md5sum')
                end

                def self.sha1
                  Digest::SHA1.hexdigest('other-sha1')
                end

                def self.sha256
                  Digest::SHA256.hexdigest('other-sha256')
                end

                def self.sha512
                  Digest::SHA512.hexdigest('other-sha512')
                end

                def self.description_md5sum
                  Digest::MD5.hexdigest("#{Attributes::Alternate.description}\n")
                end

                def self.text
                  package_control_text = Package::Control::Alternate.text
                  package_control_text.chomp!

                  <<~TEXT
                  Filename: #{filename}
                  Size: #{size}
                  MD5sum: #{md5sum}
                  SHA1: #{sha1}
                  SHA256: #{sha256}
                  SHA512: #{sha512}
                  Description-md5sum: #{description_md5sum}
                  #{package_control_text}
                  TEXT
                end
              end
            end
          end
        end
      end
    end
  end
end
