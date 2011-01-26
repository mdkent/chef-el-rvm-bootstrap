#
# Modified By:: Matthew Kent
# Original Author:: Joshua Timberman <joshua@opscode.com>
# Original Author:: Joshua Sierles <joshua@37signals.com>
# Cookbook Name:: chef
# Recipe:: server
#
# Copyright 2008-2009, Opscode, Inc
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

include_recipe "chef::client"

include_recipe "java"
include_recipe "couchdb"
include_recipe "rabbitmq_chef"
include_recipe "zlib"
include_recipe "xml"

server_gems = %w{ chef-server-api chef-solr }
server_services = { 
  "chef-server"       => "server",
  "chef-solr"         => "solr",
  "chef-solr-indexer" => "solr-indexer"
}

if node.chef.attribute?("webui_enabled")
  server_gems << "chef-server-webui"
  server_services["chef-server-webui"] = "webui"
end

server_gems.each do |gem|
  gem_package gem do
    version node.chef.server_version
  end
end

directory "/etc/chef/certificates" do
  owner "chef"
  group "root"
  mode 0700
end

server_services.each do |svc, cfg|
  service "#{svc}" do
    action :nothing 
  end

  template "/etc/chef/#{cfg}.rb" do
    source "#{cfg}.rb.erb"
    owner "chef"
    group "root"
    mode 0600
    notifies :restart, resources( :service => svc), :delayed
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

  template"/etc/init.d/#{svc}" do
    source "#{svc}.init.erb"
    owner "root"
    group "root" 
    mode 0755
    notifies :restart, resources( :service => svc), :delayed
  end

  template "/etc/logrotate.d/#{svc}" do
    source "#{svc}.logrotate.erb"
    owner "root"
    group "root" 
    mode 0644
  end

  service "#{svc}" do
    action [ :enable, :start ]
  end
end

http_request "compact chef couchDB" do
  action :post
  url "#{Chef::Config[:couchdb_url]}/chef/_compact"
  only_if do
    begin
      open("#{Chef::Config[:couchdb_url]}/chef")
      JSON::parse(open("#{Chef::Config[:couchdb_url]}/chef").read)["disk_size"] > 100_000_000
    rescue OpenURI::HTTPError
      nil
    end
  end
end

%w(nodes roles registrations clients data_bags data_bag_items users).each do |view|
  http_request "compact chef couchDB view #{view}" do
    action :post
    url "#{Chef::Config[:couchdb_url]}/chef/_compact/#{view}"
    only_if do
      begin
        open("#{Chef::Config[:couchdb_url]}/chef/_design/#{view}/_info")
        JSON::parse(open("#{Chef::Config[:couchdb_url]}/chef/_design/#{view}/_info").read)["view_index"]["disk_size"] > 100_000_000
      rescue OpenURI::HTTPError
        nil
      end
    end
  end
end

%w{chef-solr-rebuild}.each do |bin|
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
