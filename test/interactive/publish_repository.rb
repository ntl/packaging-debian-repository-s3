require_relative './interactive_init'

Controls::S3Bucket::Clear.()

distribution = Controls::Distribution.example

deb_file = Controls::Package::File.example

Commands::Package::Publish.(deb_file, distribution)

puts <<~TEXT

Add this line to /etc/apt/sources.list:

deb [arch=amd64] https://#{AWS::S3::Client::Settings.get(:bucket)}.s3.amazonaws.com #{distribution} #{Defaults.component}

TEXT
