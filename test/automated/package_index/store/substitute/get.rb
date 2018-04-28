require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Substitute" do
      context "Get" do
        context "Package Index Added" do
          control_package_index = Controls::PackageIndex.example

          context do
            substitute = Dependency::Substitute.build(PackageIndex::Store)

            substitute.add(control_package_index)

            package_index = substitute.get

            test "Returns package index that was added" do
              assert(package_index == control_package_index)
            end
          end

          context "Architecture Included" do
            architecture = Controls::Architecture::Alternate.example

            substitute = Dependency::Substitute.build(PackageIndex::Store)

            substitute.add(control_package_index, architecture)

            context "Included Architecture Given" do
              package_index = substitute.get(architecture: architecture)

              test "Returns package index that was added" do
                assert(package_index == control_package_index)
              end
            end

            context "Included Architecture Mismatch" do
              incorrect_architecture = Controls::Random.unique_text

              package_index = substitute.get(architecture: incorrect_architecture)

              test "Returns nothing" do
                assert(package_index.nil?)
              end
            end

            context "Included Architecture Omitted" do
              package_index = substitute.get

              test "Returns nothing" do
                assert(package_index.nil?)
              end
            end
          end
        end

        context "Package Index Not Added" do
          substitute = Dependency::Substitute.build(PackageIndex::Store)

          package_index = substitute.get

          test "Returns nothing" do
            assert(package_index.nil?)
          end
        end
      end
    end
  end
end
