require 'open3'
require 'rubygems'

require 'aws/s3/client'

require 'configure'; Configure.activate
require 'settings'; Settings.activate

require 'packaging/debian/schemas'

require 'packaging/debian/repository/package_index'
require 'packaging/debian/repository/package_index/get'
require 'packaging/debian/repository/package_index/put'

require 'packaging/debian/repository/release'
#require 'packaging/debian/repository/release/put'
require 'packaging/debian/repository/release/put'