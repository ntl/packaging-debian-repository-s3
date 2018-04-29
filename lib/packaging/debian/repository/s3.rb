require 'open3'
require 'rubygems'

require 'aws/s3/client'
require 'shell_command/execute'

require 'configure'; Configure.activate

require 'packaging/debian/schemas'

require 'packaging/debian/repository/s3/defaults'

require 'packaging/debian/repository/s3/log'

require 'packaging/debian/repository/s3/gpg/sign'
require 'packaging/debian/repository/s3/gpg/verify'

require 'packaging/debian/repository/s3/release'
require 'packaging/debian/repository/s3/release/transform'
require 'packaging/debian/repository/s3/release/store'
require 'packaging/debian/repository/s3/release/store/substitute'

require 'packaging/debian/repository/s3/package_index'
require 'packaging/debian/repository/s3/package_index/transform'
require 'packaging/debian/repository/s3/package_index/store'
require 'packaging/debian/repository/s3/package_index/store/substitute'

require 'packaging/debian/repository/s3/package/get'
require 'packaging/debian/repository/s3/package/get/substitute'
require 'packaging/debian/repository/s3/package/put'
require 'packaging/debian/repository/s3/package/put/substitute'

require 'packaging/debian/repository/s3/commands/package/register'
require 'packaging/debian/repository/s3/commands/package/register/telemetry'
