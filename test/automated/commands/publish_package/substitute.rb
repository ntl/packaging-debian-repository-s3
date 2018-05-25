require_relative '../../automated_init'

context "Commands" do
  context "Publish Package" do
    context "Substitute" do
      context do
        substitute = Dependency::Substitute.build(Commands::Package::Publish)

        deb_file = Controls::Package.example

        distribution = Controls::Distribution.example
        component = Controls::Component.example

        substitute.(deb_file, distribution: distribution, component: component)

        context "Published Predicate" do
          context "No Argument" do
            test "Returns true" do
              assert(substitute.published?)
            end
          end

          context "Argument Given" do
            context "Argument Is Package That Was Published" do
              test "Returns true" do
                assert(substitute.published?(deb_file))
              end
            end

            context "Argument Is Not Package That Was Published" do
              other_deb_file = Controls::Random.unique_text

              test "Returns false" do
                refute(substitute.published?(other_deb_file))
              end
            end
          end

          context "Block Given" do
            test "Package file that was published is yielded to block" do
              yielded_argument = nil

              substitute.published? { |entry| yielded_argument = entry }

              assert(yielded_argument == deb_file)
            end

            test "Distribution is yielded to block" do
              second_yielded_argument = nil

              substitute.published? { |_, dist| second_yielded_argument = dist }

              assert(second_yielded_argument == distribution)
            end

            test "Component is yielded to block" do
              third_yielded_argument = nil

              substitute.published? { |_, _, comp| third_yielded_argument = comp }

              assert(third_yielded_argument == component)
            end

            context "Block Evaluates to False" do
              test "Returns false" do
                refute(substitute.published? { false })
              end
            end

            context "Block Evaluates to True" do
              test "Returns true" do
                assert(substitute.published? { true })
              end
            end
          end
        end
      end

      context "Nothing Was Published" do
        substitute = Dependency::Substitute.build(Commands::Package::Publish)

        context "Published Predicate" do
          context "No Argument" do
            test "Returns false" do
              refute(substitute.published?)
            end
          end

          context "Block Given" do
            context "Block Evaluates to True" do
              test "Returns false" do
                refute(substitute.published? { true })
              end
            end
          end
        end
      end
    end
  end
end


