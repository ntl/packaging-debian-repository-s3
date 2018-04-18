require_relative './automated_init'

context "Package Control" do
  deb_file = Controls::Package::File.example

  comment "File location: #{deb_file}"

  test "Is file" do
    assert(File.size?(deb_file))
  end

  test "Is debian package" do
    assert((File.extname(deb_file)) == '.deb')
  end

  context "Control Attributes" do
    read_field = proc { |field|
      line = `dpkg-deb -f #{deb_file} | grep '^#{field}:'`.chomp

      _, value = line.split(/[[:blank:]]+/, 2)

      value
    }

    {
      'Package' => Controls::Package::Attributes.package,
      'Source' => Controls::Package::Attributes.source,
      'Version' => Controls::Package::Attributes.version,
      'Section' => Controls::Package::Attributes.section,
      'Priority' => Controls::Package::Attributes.priority,
      'Architecture' => Controls::Package::Attributes.architecture,
      'Essential' => 'yes',
      'Depends' => Controls::Package::Attributes.depends,
      'Pre-Depends' => Controls::Package::Attributes.pre_depends,
      'Recommends' => Controls::Package::Attributes.recommends,
      'Suggests' => Controls::Package::Attributes.suggests,
      'Enhances' => Controls::Package::Attributes.enhances,
      'Breaks' => Controls::Package::Attributes.breaks,
      'Conflicts' => Controls::Package::Attributes.conflicts,
      'Installed-Size' => Controls::Package::Attributes.installed_size.to_s,
      'Maintainer' => Controls::Package::Attributes.maintainer,
      'Description' => Controls::Package::Attributes.description,
      'Homepage' => Controls::Package::Attributes.homepage,
      'Built-Using' => Controls::Package::Attributes.built_using
    }.each do |field, control_value|
      test field do
        value = read_field.(field)

        comment "Value: #{value.inspect}"
        comment "Control: #{control_value.inspect}"

        assert(value == control_value)
      end
    end
  end

  context "Contents" do
    control_contents = Controls::Package::Contents.example

    extract_dir = Dir.mktmpdir

    `dpkg-deb -x #{deb_file} #{extract_dir}`

    control_contents.each do |file, data|
      path = File.join(extract_dir, file)

      read_data = File.read(path)

      test "#{file}" do
        assert(data == read_data)
      end
    end
  end
end
