require 'rubygems'
require 'aws/s3/client'

require 'configure'; Configure.activate
require 'schema'
require 'settings'; Settings.activate
require 'transform'

require 'package_repository/debian/client/rfc822'

require 'package_repository/debian/client/package'
require 'package_repository/debian/client/package/index'

require 'package_repository/debian/client/manifest/get'
