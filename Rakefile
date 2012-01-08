require 'rake/packagetask'
require 'find'

PACKAGE_NAME = "chef-el-rvm-bootstrap"
PACKAGE_VERSION="0.10.8-1"
PACKAGE_FULL="#{PACKAGE_NAME}-#{PACKAGE_VERSION}"
PACKAGE_DIR = "tmp"
INCLUDE_FILES = "**/*"
EXCLUDE_FILES = "tmp"

Rake::PackageTask.new(PACKAGE_NAME, PACKAGE_VERSION) do |p|
  p.package_dir = PACKAGE_DIR
  p.need_tar_gz = true
  p.package_files.include(*INCLUDE_FILES)
  p.package_files.exclude(*EXCLUDE_FILES)
end

desc "Build a bootstrap tar.gz"
task :build_bootstrap do
  rm_rf PACKAGE_DIR
  Rake::Task[ "package" ].invoke

  # Package again, chef-solo requires cookbooks/ in path (CHEF-2001)
  chdir(PACKAGE_DIR) do
    rm_f File.join("#{PACKAGE_FULL}.tar.gz")
    chdir(PACKAGE_FULL) do
        sh %{mkdir cookbooks}
        sh %{mv -f * cookbooks || :}
        sh %{tar zcvf ../#{PACKAGE_FULL}.tar.gz cookbooks}
    end
  end
end
