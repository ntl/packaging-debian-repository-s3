require_relative './automated_init'

context "Package Control" do
  package = Controls::Package::Metadata.package
  version = Controls::Package::Metadata.version
  maintainer = Controls::Package::Metadata.maintainer
  description = Controls::Package::Metadata.description
  homepage = Controls::Package::Metadata.homepage
  depends = Controls::Package::Metadata.depends
  priority = Controls::Package::Metadata.priority
  architecture = Controls::Package::Metadata.architecture

  contents = Controls::Package::Contents.example

  deb_file = Controls::Package.example(
    package: package,
    version: version,
    contents: contents,
    maintainer: maintainer,
    description: description,
    homepage: homepage,
    depends: depends,
    priority: priority,
    architecture: architecture
  )

  comment "File location: #{deb_file}"

  test "Is file" do
    assert(File.size?(deb_file))
  end

  test "Is debian package" do
    assert((File.extname(deb_file)) == '.deb')
  end

  context "Metadata" do
    read_field = Controls::Package::Metadata::GetField

    context "Name "do
      assert(read_field.(deb_file, :package) == package)
    end

    context "Version" do
      assert(read_field.(deb_file, :version) == version)
    end

    context "Maintainer" do
      assert(read_field.(deb_file, :maintainer) == maintainer)
    end

    context "Description" do
      assert(read_field.(deb_file, :description) == description)
    end

    context "Homepage" do
      assert(read_field.(deb_file, :homepage) == homepage)
    end

    context "Dependencies" do
      assert(read_field.(deb_file, :depends) == depends)
    end

    context "Priority" do
      assert(read_field.(deb_file, :priority) == priority)
    end

    context "Architecture" do
      assert(read_field.(deb_file, :architecture) == architecture)
    end
  end

  context "Contents" do
    extract_dir = Controls::Package::Extract.(deb_file)

    contents.each do |file, data|
      path = File.join(extract_dir, file)

      read_data = File.read(path)

      test "#{file}" do
        assert(data == read_data)
      end
    end
  end
end
