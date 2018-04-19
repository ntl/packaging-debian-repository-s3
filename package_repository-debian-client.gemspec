# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'package_repository-debian-client'
  s.version = '0.0.0.0'
  s.summary = 'Client library for uploading and querying debian repositories'
  s.description = ' '

  s.authors = ['BTC Labs']
  s.email = ' '
  s.homepage = 'https://github.com/btc-labs/package-repository-debian-client'
  s.licenses = ['Proprietary']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.4.0'

  s.add_runtime_dependency 'evt-configure'
  s.add_runtime_dependency 'evt-schema'
  s.add_runtime_dependency 'evt-settings'
  s.add_runtime_dependency 'evt-transform'

  s.add_runtime_dependency 'aws-s3-client'
  s.add_runtime_dependency 'packaging-debian-schemas'

  s.add_development_dependency 'test_bench'
end
