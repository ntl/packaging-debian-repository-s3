require_relative '../../../automated_init'

context "Release" do
  context "Store" do
    context "Put" do
      context "Optional Distribution" do
        distribution = Controls::Distribution.example

        release = Controls::Release.example

        context "Given" do
          override_distribution = Controls::Distribution::Alternate.example

          store = Release::Store.new(distribution)

          put_key, _ = store.put(release, distribution: override_distribution)

          test "Release is uploaded to given distribution" do
            control_key = Controls::Release::Path.example(override_distribution)

            assert(put_key == control_key)
          end
        end

        context "Omitted" do
          store = Release::Store.new(distribution)

          put_key, _ = store.put(release)

          test "Release is uploaded to original distribution" do
            control_key = Controls::Release::Path.example(distribution)

            assert(put_key == control_key)
          end
        end
      end
    end
  end
end
