require 'open3'
require 'rubygems'

require 'aws/s3/client'

require 'configure'; Configure.activate

require 'packaging/debian/schemas'
require 'packaging/debian/package'

require 'packaging/debian/repository/defaults'

require 'packaging/debian/repository/log'

require 'packaging/debian/repository/gpg/sign'
require 'packaging/debian/repository/gpg/verify'

require 'packaging/debian/repository/release'
require 'packaging/debian/repository/release/transform'
require 'packaging/debian/repository/release/get'
require 'packaging/debian/repository/release/put'

require 'packaging/debian/repository/package_index'
require 'packaging/debian/repository/package_index/transform'
require 'packaging/debian/repository/package_index/store'

require 'packaging/debian/repository/package/get'
require 'packaging/debian/repository/package/get/substitute'
require 'packaging/debian/repository/package/put'
require 'packaging/debian/repository/package/put/substitute'
