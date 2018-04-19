ENV['LOG_TAGS'] ||= '_untagged,aws_s3_client,package_repository_debian_client'
ENV['LOG_LEVEL'] ||= 'trace'

require_relative '../test_init'
