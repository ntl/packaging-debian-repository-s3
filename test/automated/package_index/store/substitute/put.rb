require_relative '../../../automated_init'

context "Package Index" do
  context "Store" do
    context "Substitute" do
      context "Put" do
        package_index = Controls::PackageIndex.example

        context do
          substitute = Dependency::Substitute.build(PackageIndex::Store)

          put_key, put_text = substitute.put(package_index)

          context "Return Value" do
            test "First value is remote location" do
              control_object_key = Controls::PackageIndex::Path.example(distribution: substitute.distribution)

              assert(put_key == control_object_key)
            end

            test "Second value is raw, compressed text" do
              control_text = Controls::PackageIndex::Text::Compressed.example

              assert(put_text == control_text)
            end
          end

          context "Put Predicate" do
            context "No Argument" do
              test "Returns true" do
                assert(substitute.put?)
              end
            end

            context "Argument Given" do
              context "Argument Is Package Index That Was Put" do
                test "Returns true" do
                  assert(substitute.put?(package_index))
                end
              end

              context "Argument Is Not Package Index That Was Put" do
                other_package_index = PackageIndex.new

                test "Returns false" do
                  refute(substitute.put?(other_package_index))
                end
              end
            end

            context "Block Given" do
              test "Package index that was put is yielded to block" do
                yielded_argument = nil

                substitute.put? { |package_index| yielded_argument = package_index }

                assert(yielded_argument == package_index)
              end

              context "Block Evaluates to False" do
                test "Returns false" do
                  refute(substitute.put? { false })
                end
              end

              context "Block Evaluates to True" do
                test "Returns true" do
                  assert(substitute.put? { true })
                end
              end
            end
          end
        end

        context "Component Given" do
          component = Controls::Component::Alternate.example

          substitute = Dependency::Substitute.build(PackageIndex::Store)

          substitute.put(package_index, component: component)

          context "Put Predicate" do
            context "Block Given" do
              test "Component is yielded to block" do
                second_yielded_argument = nil

                substitute.put? { |_, comp| second_yielded_argument = comp }

                assert(second_yielded_argument == component)
              end
            end
          end
        end

        context "Architecture Given" do
          architecture = Controls::Architecture::Alternate.example

          substitute = Dependency::Substitute.build(PackageIndex::Store)

          substitute.put(package_index, architecture: architecture)

          context "Put Predicate" do
            context "Block Given" do
              test "Architecture is yielded to block" do
                third_yielded_argument = nil

                substitute.put? { |_, _, arch| third_yielded_argument = arch }

                assert(third_yielded_argument == architecture)
              end
            end
          end
        end

        context "Nothing Was Put" do
          substitute = Dependency::Substitute.build(PackageIndex::Store)

          context "Put Predicate" do
            context "No Argument" do
              test "Returns false" do
                refute(substitute.put?)
              end
            end

            context "Block Given" do
              context "Block Evaluates to True" do
                test "Returns false" do
                  refute(substitute.put? { true })
                end
              end
            end
          end
        end
      end
    end
  end
end
