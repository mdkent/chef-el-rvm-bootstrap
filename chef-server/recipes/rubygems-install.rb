#
# Modified By:: Matthew Kent
# Original Author:: Joshua Timberman <joshua@opscode.com>
# Original Author:: Joshua Sierles <joshua@37signals.com>
#
# Cookbook Name:: chef
# Recipe:: bootstrap_server
#
# Copyright 2009-2010, Opscode, Inc.
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
#

recipe_name = self.recipe_name
cookbook_name = self.cookbook_name

include_recipe "chef-client::config"
include_recipe "couchdb"
include_recipe "java"
include_recipe "chef-server::rabbitmq"
include_recipe "gecode"
include_recipe "zlib"
include_recipe "xml"

server_gems = %w{ chef-server-api chef-solr chef-expander }
server_services = %w{ chef-solr chef-expander chef-server }

if node['chef_server']['webui_enabled']
  server_gems << "chef-server-webui"
  server_services << "chef-server-webui"
end

chef_version = node['chef_packages']['chef']['version']

server_gems.each do |gem|
  gem_package gem do
    version chef_version
  end
end

server_services.each do |svc|
  service "#{svc}" do
    action :nothing 
  end
end

template "#{node['chef_server']['conf_dir']}/server.rb" do
  source "server.rb.erb"
  owner "chef"
  group "root"
  mode 0600
  variables(
    :recipe_name => recipe_name,
    :cookbook_name => cookbook_name
  )
  notifies :restart, "service[chef-server]", :delayed
  if node['chef_server']['webui_enabled']
    notifies :restart, "service[chef-server-webui]", :delayed
  end
end

template "#{node['chef_server']['conf_dir']}/solr.rb" do
  source "solr.rb.erb"
  owner "chef"
  group "root"
  mode 0600
  variables(
    :recipe_name => recipe_name,
    :cookbook_name => cookbook_name
  )
  notifies :restart, "service[chef-solr]", :delayed
  notifies :restart, "service[chef-expander]", :delayed
end

link "#{node['chef_server']['conf_dir']}/webui.rb" do
  to "#{node['chef_server']['conf_dir']}/server.rb"
end

link "#{node['chef_server']['conf_dir']}/expander.rb" do
  to "#{node['chef_server']['conf_dir']}/solr.rb"
end

%w{ cache search_index }.each do |dir|
  directory "#{node['chef_server']['path']}/#{dir}" do
    owner "chef"
    group "root"
    mode 0755
  end
end

directory "#{node['chef_server']['conf_dir']}/certificates" do
  owner "chef"
  group "root"
  mode 0700
end

# install solr
execute "chef-solr-installer" do
  command  "chef-solr-installer -c #{node['chef_server']['conf_dir']}/solr.rb -u chef -g root"
  path %w{ /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin }
  not_if { ::File.exists?("#{node['chef_server']['path']}/solr/home") }
end

gems_dir = node['languages']['ruby']['gems_dir']

server_services.each do |svc|
  template "/etc/init.d/#{svc}" do
    source "redhat/init.d/#{svc}.erb"
    mode 0755
    variables(
      :recipe_name => recipe_name,
      :cookbook_name => cookbook_name
    )
    notifies :restart, "service[#{svc}]", :delayed
  end

  template "/usr/bin/#{svc}" do
    source "rvm_wrapper.bin.erb"
    owner "root"
    group "root"
    mode 0755
    variables(
      :recipe_name => recipe_name,
      :cookbook_name => cookbook_name,
      :binary => svc
    )
  end

  template "/etc/logrotate.d/#{svc}" do
    source "redhat/logrotate.d/#{svc}.erb"
    owner "root"
    group "root"
    variables(
      :recipe_name => recipe_name,
      :cookbook_name => cookbook_name
    )
    mode 0644
  end

  service "#{svc}" do
    supports :status => true
    action [ :enable, :start ]
  end
end

%w{chef-expanderctl chef-expander-vnode chef-solr-rebuild}.each do |bin|
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
