# Source install for the running ruby

version = "1.4.1"
package = "ruby-shadow-#{version}"
package_dir = "shadow-#{version}"

ruby = node[:languages][:ruby]

dest = nil
if ruby[:version] =~ %r{^1.9}
  dest = "/usr/local/src/ruby-shadow/1.9"
elsif ruby[:version] =~ %r{^1.8}
  dest = "/usr/local/src/ruby-shadow/1.8"
end

remote_directory dest do
  source "ruby-shadow"
end

if ruby[:version] =~ %r{^1.9}
  bash "extract and patch shadow for ruby 1.9" do
    user "root"
    cwd dest
    code <<-EOH
      tar zxf #{package}.tar.gz
      cd #{package_dir}
      patch -p0 < ../ruby-shadow-#{version}-extconf-fixes.patch
      patch -p0 < ../ruby-shadow-#{version}-update-depend-to-ruby19.patch
      patch -p0 < ../ruby-shadow-#{version}-update-shadowc-to-ruby19.patch
    EOH
    not_if "cat #{dest}/#{package_dir}/depend | grep 'ruby/io.h'"
  end
elsif ruby[:version] =~ %r{^1.8}
  bash "extract shadow for ruby 1.8" do
    user "root"
    cwd dest 
    code <<-EOH
      tar zxf #{package}.tar.gz
    EOH
    not_if "cat #{dest}/#{package_dir}/depend | grep 'rubyio.h'"
  end
end

bash "build and install shadow" do
  user "root"
  cwd "#{dest}/#{package_dir}"
  code <<-EOH
    #{ruby[:ruby_bin]} extconf.rb
    make
    make install
    make clean
  EOH
  not_if do 
    begin
      require 'shadow'
      true
    rescue LoadError
      false
    end
  end
end
