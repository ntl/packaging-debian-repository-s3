require_relative '../../automated_init'

context "Package" do
  context "Put" do
    context "Substitute" do
      control_data = 'some-data'

      context "Actuated With File" do
        substitute = Dependency::Substitute.build(Package::Put)

        file = Tempfile.new
        file.write(control_data)
        file.rewind

        filename = File.basename(file.path)

        substitute.(file)

        context "Put Predicate" do
          context "No Arguments Given" do
            test "Returns true" do
              assert(substitute.put?)
            end
          end

          context "Given Argument Matches Filename" do
            test "Returns true" do
              assert(substitute.put?(filename))
            end
          end

          context "Given Argument Does Not Match Filename" do
            other_filename = Controls::Random.unique_text

            test "Returns false" do
              refute(substitute.put?(other_filename))
            end
          end
        end

      ensure
        file.unlink
      end

      context "Actuated With Data Stream" do
        data_stream = StringIO.new(control_data)
        filename = Controls::Package.filename

        context do
          substitute = Dependency::Substitute.build(Package::Put)

          substitute.(data_stream, filename)

          context "Put Predicate" do
            context "No Arguments Given" do
              test "Returns true" do
                assert(substitute.put?)
              end
            end

            context "Given Argument Matches Filename" do
              test "Returns true" do
                assert(substitute.put?(filename))
              end
            end

            context "Given Argument Does Not Match Filename" do
              other_filename = Controls::Random.unique_text

              test "Returns false" do
                refute(substitute.put?(other_filename))
              end
            end
          end
        end

        context "Missing Filename" do
          substitute = Dependency::Substitute.build(Package::Put)

          test "Raises ArgumentError" do
            assert proc { substitute.(data_stream) } do
              raises_error?(ArgumentError)
            end
          end
        end
      end

      context "Nothing Was Put" do
        substitute = Dependency::Substitute.build(Package::Put)

        context "Put Predicate" do
          test "Returns false" do
            refute(substitute.put?)
          end
        end
      end
    end
  end
end
