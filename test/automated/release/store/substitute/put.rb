require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Substitute" do
      context "Put" do
        context do
          substitute = Dependency::Substitute.build(Release::Store)

          release = Controls::Release.example

          put_key, put_text = substitute.put(release)

          context "Return Value" do
            test "First value is remote location" do
              control_object_key = Controls::Release::Path.example(substitute.distribution)

              assert(put_key == control_object_key)
            end

            test "Second value is raw, signed text" do
              unsigned_put_text = Controls::GPG::Clearsign::Signature::Remove.(put_text)

              assert(unsigned_put_text == Controls::Release::Text.example)
            end
          end

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

              test "Object key is yielded to block" do
                second_yielded_argument = nil

                substitute.put? { |_, key| second_yielded_argument = key }

                assert(second_yielded_argument == put_key)
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
