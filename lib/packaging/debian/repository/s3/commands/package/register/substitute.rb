module Packaging
  module Debian
    module Repository
      module S3
        module Commands
          module Package
            class Register
              module Substitute
                def self.build
                  Register.new
                end

                class Register
                  def call(index_entry, distribution: nil, component: nil)
                    registration = Registration.new(index_entry, distribution, component)

                    registrations << registration

                    registration
                  end

                  def registered?(index_entry=nil, &block)
                    block ||= proc { |entry| index_entry.nil? || entry == index_entry }

                    registrations.any? do |registration|
                      block.(*registration.to_a)
                    end
                  end

                  def registrations
                    @registrations ||= []
                  end

                  Registration = Struct.new(:index_entry, :distribution, :component)
                end
              end
            end
          end
        end
      end
    end
  end
end
