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

            package_index = substitute.fetch

            test "Returns package index that was added" do
              assert(package_index == control_package_index)
            end
          end

          context "Distribution Included" do
            distribution = Controls::Distribution::Alternate.example

            substitute = Dependency::Substitute.build(PackageIndex::Store)

            substitute.add(control_package_index, distribution: distribution)

            context "Included Distribution Given" do
              package_index = substitute.fetch(distribution: distribution)

              test "Returns package index that was added" do
                assert(package_index == control_package_index)
              end
            end

            context "Included Distribution Mismatch" do
              incorrect_distribution = Controls::Random.unique_text

              package_index = substitute.fetch(distribution: incorrect_distribution)

              test "Returns uninitialized package index" do
                assert(package_index == PackageIndex.new)
              end
            end

            context "Included Component Omitted" do
              package_index = substitute.fetch

              test "Returns uninitialized package index" do
                assert(package_index == PackageIndex.new)
              end
            end
          end

          context "Component Included" do
            component = Controls::Component::Alternate.example

            substitute = Dependency::Substitute.build(PackageIndex::Store)

            substitute.add(control_package_index, component: component)

            context "Included Component Given" do
              package_index = substitute.fetch(component: component)

              test "Returns package index that was added" do
                assert(package_index == control_package_index)
              end
            end

            context "Included Component Mismatch" do
              incorrect_component = Controls::Random.unique_text

              package_index = substitute.fetch(component: incorrect_component)

              test "Returns uninitialized package index" do
                assert(package_index == PackageIndex.new)
              end
            end

            context "Included Component Omitted" do
              package_index = substitute.fetch

              test "Returns uninitialized package index" do
                assert(package_index == PackageIndex.new)
              end
            end
          end

          context "Architecture Included" do
            architecture = Controls::Architecture::Alternate.example

            substitute = Dependency::Substitute.build(PackageIndex::Store)

            substitute.add(control_package_index, architecture: architecture)

            context "Included Architecture Given" do
              package_index = substitute.fetch(architecture: architecture)

              test "Returns package index that was added" do
                assert(package_index == control_package_index)
              end
            end

            context "Included Architecture Mismatch" do
              incorrect_architecture = Controls::Random.unique_text

              package_index = substitute.fetch(architecture: incorrect_architecture)

              test "Returns uninitialized package index" do
                assert(package_index == PackageIndex.new)
              end
            end

            context "Included Architecture Omitted" do
              package_index = substitute.fetch

              test "Returns uninitialized package index" do
                assert(package_index == PackageIndex.new)
              end
            end
          end
        end

        context "Package Index Not Added" do
          substitute = Dependency::Substitute.build(PackageIndex::Store)

          package_index = substitute.fetch

          test "Returns uninitialized package index" do
            assert(package_index == PackageIndex.new)
          end
        end
      end
    end
  end
end
