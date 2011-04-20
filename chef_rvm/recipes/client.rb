#
# Modified By:: Matthew Kent
# Original Author:: Joshua Timberman <joshua@opscode.com>
# Original Author:: Joshua Sierles <joshua@37signals.com>
# Cookbook Name:: chef_rvm
# Recipe:: client
#
# Copyright 2008-2010, Opscode, Inc
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

gem_package "chef" do
  version node[:chef_rvm][:client_version]
end

user "chef" do
  system true
  shell "/sbin/nologin"
  home node[:chef_rvm][:path]
end

chef_dirs = [
  "/etc/chef",
  node[:chef_rvm][:path],
  node[:chef_rvm][:serve_path],
  node[:chef_rvm][:run_path],
  node[:chef_rvm][:cache_path],
  node[:chef_rvm][:backup_path],
  node[:chef_rvm][:log_dir]
].uniq

chef_dirs.each do |dir|
  directory dir do
    recursive true
    owner "chef"
    group "root" 
    mode 0755
  end
end

ruby_block "reload_client_config" do
  block do
    Chef::Config.from_file("/etc/chef/client.rb")
  end
  action :nothing
end

%w{client solo}.each do |cfg|
  template "/etc/chef/#{cfg}.rb" do
    source "#{cfg}.rb.erb"
    owner "root"
    group "root"
    mode 0644
    notifies :create, resources(:ruby_block => "reload_client_config")
    variables(
      :recipe_name => recipe_name,
      :cookbook_name => cookbook_name
    )
  end
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

template "/etc/init.d/chef-client" do
  source "chef-client.init.erb"
  owner "root"
  group "root" 
  mode 0755
  variables(
    :recipe_name => recipe_name,
    :cookbook_name => cookbook_name
  )
end

template "/etc/logrotate.d/chef-client" do
  source "chef-client.logrotate.erb"
  owner "root"
  group "root" 
  mode 0644
  variables(
    :recipe_name => recipe_name,
    :cookbook_name => cookbook_name
  )
end

log "Add the chef_rvm::delete_validation recipe to the run list to remove the #{Chef::Config[:validation_key]}." do
  only_if { ::File.exists?(Chef::Config[:validation_key]) }
end

# required for user password management
include_recipe "ruby-shadow::source"
