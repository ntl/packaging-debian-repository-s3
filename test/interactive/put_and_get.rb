require_relative './interactive_init'

Controls::S3Bucket::Clear.()

package_index = Controls::PackageIndex.example

PackageIndex::Put.(package_index)

read_package_index = PackageIndex::Get.()

pp read_package_index
