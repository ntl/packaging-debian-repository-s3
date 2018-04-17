require 'rubygems'
require 'aws/s3/client'

require 'configure'; Configure.activate
require 'settings'; Settings.activate

require 'package_repository/debian/client/manifest/get'
