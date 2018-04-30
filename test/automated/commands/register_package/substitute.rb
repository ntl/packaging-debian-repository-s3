require_relative '../../automated_init'

context "Commands" do
  context "Register Package" do
    context "Substitute" do
      context do
        substitute = Dependency::Substitute.build(Commands::Package::Register)

        index_entry = Controls::PackageIndex::Entry.example

        component = Controls::Component.example

        substitute.(index_entry, component: component)

        context "Registered Predicate" do
          context "No Argument" do
            test "Returns true" do
              assert(substitute.registered?)
            end
          end

          context "Argument Given" do
            context "Argument Is Package That Was Registered" do
              test "Returns true" do
                assert(substitute.registered?(index_entry))
              end
            end

            context "Argument Is Not Package That Was Registered" do
              other_index_entry = PackageIndex::Entry.new

              test "Returns false" do
                refute(substitute.registered?(other_index_entry))
              end
            end
          end

          context "Block Given" do
            test "Package that was registered is yielded to block" do
              yielded_argument = nil

              substitute.registered? { |entry| yielded_argument = entry }

              assert(yielded_argument == index_entry)
            end

            test "Component is yielded to block" do
              second_yielded_argument = nil

              substitute.registered? { |_, comp| second_yielded_argument = comp }

              assert(second_yielded_argument == component)
            end

            context "Block Evaluates to False" do
              test "Returns false" do
                refute(substitute.registered? { false })
              end
            end

            context "Block Evaluates to True" do
              test "Returns true" do
                assert(substitute.registered? { true })
              end
            end
          end
        end
      end

      context "Nothing Was Registered" do
        substitute = Dependency::Substitute.build(Commands::Package::Register)

        context "Registered Predicate" do
          context "No Argument" do
            test "Returns false" do
              refute(substitute.registered?)
            end
          end

          context "Block Given" do
            context "Block Evaluates to True" do
              test "Returns false" do
                refute(substitute.registered? { true })
              end
            end
          end
        end
      end
    end
  end
end

