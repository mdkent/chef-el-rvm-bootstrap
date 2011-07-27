#
# Modified By:: Matthew Kent
# Original Author:: Joshua Timberman (<joshua@opscode.com>)
# Original Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: chef
# Recipe:: bootstrap_client
#
# Copyright 2009-2011, Opscode, Inc.
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
#

include_recipe "chef-client::config"

# COOK-635 account for alternate gem paths
# try to use the bin provided by the node attribute
if ::File.executable?(node["chef_client"]["bin"])
  client_bin = node["chef_client"]["bin"]
# search for the bin in some sane paths
elsif (chef_in_sane_path=Chef::Client::SANE_PATHS.map{|p| p="#{p}/chef-client";p if ::File.executable?(p)}.compact.first) && chef_in_sane_path
  client_bin = chef_in_sane_path
# last ditch search for a bin in PATH
elsif (chef_in_path=%x{which chef-client}.chomp) && ::File.executable?(chef_in_path)
  client_bin = chef_in_path
else
  raise "Could not locate the chef-client bin in any known path. Please set the proper path by overriding node['chef_client']['bin'] in a role."
end

dist_dir = "redhat"
conf_dir = "sysconfig"

template "/etc/init.d/chef-client" do
  source "#{dist_dir}/init.d/chef-client.erb"
  mode 0755
  variables(
    :client_bin => client_bin
  )
  notifies :restart, "service[chef-client]", :delayed
end

template "/etc/#{conf_dir}/chef-client" do
  source "#{dist_dir}/#{conf_dir}/chef-client.erb"
  mode 0644
  notifies :restart, "service[chef-client]", :delayed
end

template "/etc/logrotate.d/chef-client" do
  source "#{dist_dir}/logrotate.d/chef-client.logrotate.erb"
  owner "root"
  group "root"
  mode 0644
end

service "chef-client" do
  supports :status => true, :restart => true
  action :enable
end
