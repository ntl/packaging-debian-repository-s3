module PackageRepository
  module Debian
    module Client
      module ControlFile
        module Attributes
          def self.included(cls)
            cls.class_exec do
              attribute :package, String
              attribute :source, String
              attribute :version, String
              attribute :section, String
              attribute :priority, String
              attribute :essential
              attribute :depends, String
              attribute :installed_size, Integer
              attribute :maintainer, String
              attribute :description, String
              attribute :homepage, String
              attribute :built_using, String
            end
          end
        end
      end
    end
  end
end
