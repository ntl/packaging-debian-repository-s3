require 'rubygems'
require 'aws/s3/client'

require 'configure'; Configure.activate
require 'schema'
require 'settings'; Settings.activate
require 'transform'

require 'package_repository/debian/client/rfc822'

require 'package_repository/debian/client/control_file/attributes'

require 'package_repository/debian/client/manifest'
require 'package_repository/debian/client/manifest/transform'

require 'package_repository/debian/client/manifest/get'
