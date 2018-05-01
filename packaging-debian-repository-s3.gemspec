# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'packaging-debian-repository-s3'
  s.version = '0.1.0.2'
  s.summary = 'Library for publishing debian packages to S3 repositories'
  s.description = ' '

  s.authors = ['BTC Labs']
  s.email = ' '
  s.homepage = 'https://github.com/btc-labs/packaging-debian-repository-s3'
  s.licenses = ['Proprietary']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.4.0'

  s.add_runtime_dependency 'evt-configure'
  s.add_runtime_dependency 'evt-schema'
  s.add_runtime_dependency 'evt-transform'

  s.add_runtime_dependency 'aws-s3-client'
  s.add_runtime_dependency 'packaging-debian-schemas'
  s.add_runtime_dependency 'shell_command-execute'

  s.add_development_dependency 'test_bench'
end
