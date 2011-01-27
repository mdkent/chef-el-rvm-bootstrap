require 'rake/packagetask'

NAME = "chef-el-bootstrap"
PACKAGE_DIR = "tmp"
INCLUDE_FILES = "**/*"
EXCLUDE_FILES = "Rakefile", "tmp"

Rake::PackageTask.new(NAME, :noversion) do |p|
  p.package_dir = PACKAGE_DIR
  p.need_tar_gz = true
  p.package_files.include(*INCLUDE_FILES)
  p.package_files.exclude(*EXCLUDE_FILES)
end

desc "Build a bootstrap.tar.gz"
task :build_bootstrap do
  rm_rf PACKAGE_DIR
  Rake::Task[ "package" ].invoke

  chdir(PACKAGE_DIR) do
    rm_f File.join("#{NAME}.tar.gz")
    chdir(NAME) do
      sh %{mkdir cookbooks}
      sh %{mv -f * cookbooks || :}
      sh %{tar zcvf ../#{NAME}.tar.gz .}
    end
  end
end
