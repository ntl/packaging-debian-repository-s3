require_relative '../../automated_init'

context "Commands" do
  context "Register Package" do
    context "Architecture Independent Package" do
      architecture = 'all'

      index_entry = Controls::PackageIndex::Entry.example(architecture: architecture)

      distribution = Controls::Distribution.example

      context do
        release = Controls::Release.example

        release_architectures = release.architectures
        assert(release_architectures.count > 1)

        register_package = Commands::Package::Register.new
        register_package.distribution = distribution

        release_store = register_package.release_store
        release_store.add(release)

        package_index_store = register_package.package_index_store

        register_package.(index_entry)

        test "Package is added to index of each architecture" do
          release_architectures.each do |arch|
            comment "Architecture: #{arch}"

            added_to_index = package_index_store.put? do |package_index|
              package_index.added?(index_entry.filename)
            end

            assert(added_to_index)
          end
        end

        test "`all' architecture is not added to release" do
          refute(release_store.put? { |release|
            release.architectures.include?(architecture)
          })
        end
      end

      context "Release Architectures Field is Empty" do
        register_package = Commands::Package::Register.new
        register_package.distribution = distribution

        test "Raises error" do
          assert proc { register_package.(index_entry) } do
            raises_error?(Commands::Package::Register::UnknownArchitecturesError)
          end
        end
      end
    end
  end
end
