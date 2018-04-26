require_relative './interactive_init'

Controls::S3Bucket::Clear.()

package = Controls::Package.example
package_text = Controls::Package::Text.example

package_index = Controls::PackageIndex.example
package_index_text = Controls::PackageIndex::Text.example

PackageIndex::Put.(package_index)

release = Controls::Release::Minimal.example

release.architectures = [Controls::Architecture.example]
release.components = [Controls::Component.example]
release.date = Time.now.utc
#release.valid_until = (Time.now + (60 * 60 * 24 * 365)).utc
#release.signed_by = '01C7 A9E7 29A3 C4DC A158  B84C 205D 882F B364 A0C1'

package_filename = "#{package.name}-#{package.version}.deb"

release.sha256 = <<~SHA256

#{Digest::SHA256.hexdigest(package_index_text)} #{package_index_text.bytesize} #{Controls::Component.example}/binary-#{Controls::Architecture.example}/Packages.gz
#{Digest::SHA256.hexdigest(package_text)} #{package_text.bytesize} #{Controls::Component.example}/binary-#{Controls::Architecture.example}/#{package_filename}
SHA256

Release::Put.(release)

puts <<~TEXT

Add this line to /etc/apt/sources.list:

deb [arch=amd64] https://#{AWS::S3::Client::Settings.get(:bucket)}.s3.amazonaws.com #{Controls::Distribution.example} #{Controls::Component.example}

TEXT
