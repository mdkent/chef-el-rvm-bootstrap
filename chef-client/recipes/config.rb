#
# Modified By:: Matthew Kent
# Original Author:: Joshua Timberman (<joshua@opscode.com>)
# Original Author:: Joshua Sierles (<joshua@37signals.com>)
# Original Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: chef
# Recipe:: client
#
# Copyright 2008-2011, Opscode, Inc
# Copyright 2009, 37signals
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

recipe_name = self.recipe_name
cookbook_name = self.cookbook_name

chef_node_name = Chef::Config[:node_name] == node['fqdn'] ? false : Chef::Config[:node_name]

gem_package "chef" do
  version node['chef_packages']['chef']['version']
end

user "chef" do
  system true
  shell "/sbin/nologin"
  home node["chef_client"]["path"]
end

%w{conf_dir path run_path cache_path backup_path log_dir}.each do |key|
  directory node['chef_client'][key] do
    recursive true
    owner "chef"
    group "root" 
    mode 0755
  end
end

template "#{node["chef_client"]["conf_dir"]}/client.rb" do
  source "client.rb.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :recipe_name => recipe_name,
    :cookbook_name => cookbook_name,
    :chef_node_name => chef_node_name
  )
  notifies :create, "ruby_block[reload_client_config]"
end

template "#{node["chef_client"]["conf_dir"]}/solo.rb" do
  source "solo.rb.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :recipe_name => recipe_name,
    :cookbook_name => cookbook_name
  )
end

ruby_block "reload_client_config" do
  block do
    Chef::Config.from_file("#{node["chef_client"]["conf_dir"]}/client.rb")
  end
  action :nothing
end

%w{chef-client chef-solo knife ohai shef}.each do |bin|
  template "/usr/bin/#{bin}" do
    source "rvm_wrapper.bin.erb"
    owner "root"
    group "root"
    mode 0755
    variables(
      :recipe_name => recipe_name,
      :cookbook_name => cookbook_name,
      :binary => bin
    )
  end
end

# Required for user password management
include_recipe "ruby-shadow::source"

%w{
  chef-client.8 chef-solo.8 knife.1 knife-bootstrap.1
  knife-client.1 knife-configure.1 knife-cookbook.1 knife-cookbook-site.1
  knife-data-bag.1 knife-environment.1 knife-exec.1 knife-index.1
  knife-node.1 knife-role.1 knife-search.1 knife-ssh.1
  knife-status.1 knife-tag.1 shef.1
}.each do |man|
  type = man.split('.')[1]
  man_dir = File.join(node["chef_packages"]["chef"]["chef_root"], "..", "distro/common/man/man#{type}")
  src = File.join(man_dir, man)
  dst = File.join("/usr/share/man/man#{type}", man)

  man_content = IO.read(src)

  file dst do
    content man_content
    mode 0644
  end
end
