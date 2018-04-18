module PackageRepository
  module Debian
    module Client
      class Manifest
        include Schema::DataStructure

        attribute :suite, String
        attribute :component, String
        attribute :architecture, String

        attribute :packages, Array, default: proc { [] }

        class Package
          include Schema::DataStructure

          attribute :filename, String
          attribute :size, Integer
          attribute :md5, String
          attribute :description_md5, String

          include ControlFile::Attributes
        end
      end
    end
  end
end
