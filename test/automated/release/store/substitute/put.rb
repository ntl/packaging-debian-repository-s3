require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Substitute" do
      context "Put" do
        context do
          substitute = Dependency::Substitute.build(Release::Store)

          release = Controls::Release.example

          substitute.put(release)

          context "Put Predicate" do
            context "No Argument" do
              test "Returns true" do
                assert(substitute.put?)
              end
            end

            context "Argument Given" do
              context "Argument Is Release That Was Put" do
                test "Returns true" do
                  assert(substitute.put?(release))
                end
              end

              context "Argument Is Not Release That Was Put" do
                other_release = Release.new

                test "Returns false" do
                  refute(substitute.put?(other_release))
                end
              end
            end

            context "Block Given" do
              test "Release that was put is yielded to block" do
                yielded_argument = nil

                substitute.put? { |release| yielded_argument = release }

                assert(yielded_argument == release)
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

        context "Nothing Was Put" do
          substitute = Dependency::Substitute.build(Release::Store)

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
