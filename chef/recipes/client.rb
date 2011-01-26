#
# Modified By:: Matthew Kent
# Original Author:: Joshua Timberman <joshua@opscode.com>
# Original Author:: Joshua Sierles <joshua@37signals.com>
# Cookbook Name:: chef
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

gem_package "chef" do
  version node[:chef][:client_version]
end

user "chef" do
  system true
  shell "/sbin/nologin"
  home node[:chef][:path]
end

chef_dirs = [
  "/etc/chef",
  node[:chef][:path],
  node[:chef][:serve_path],
  node[:chef][:run_path],
  node[:chef][:cache_path],
  node[:chef][:backup_path],
  node[:chef][:log_dir]
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

template "/etc/chef/client.rb" do
  source "client.rb.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :create, resources(:ruby_block => "reload_client_config")
end

template"/etc/init.d/chef-client" do
  source "chef-client.init.erb"
  owner "root"
  group "root" 
  mode 0755
end

template "/etc/sysconfig/chef-client" do
  source "chef-client.sysconfig.erb"
  owner "root"
  group "root" 
  mode 0644
end

template "/etc/logrotate.d/chef-client" do
  source "chef-client.logrotate.erb"
  owner "root"
  group "root" 
  mode 0644
end

log "Add the chef::delete_validation recipe to the run list to remove the #{Chef::Config[:validation_key]}." do
  only_if { ::File.exists?(Chef::Config[:validation_key]) }
end
