require 'rubygems'
require 'aws/s3/client'

require 'configure'; Configure.activate
require 'settings'; Settings.activate

require 'packaging/debian/schemas'

require 'package_repository/debian/client/package_index'
require 'package_repository/debian/client/package_index/get'
require 'package_repository/debian/client/package_index/put'

require 'package_repository/debian/client/release'
require 'package_repository/debian/client/release/put'
