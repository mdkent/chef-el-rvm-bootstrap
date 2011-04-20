#
# Modified By:: Matthew Kent
# Original Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: chef_rvm
# Attributes:: default
#
# Copyright 2008-2010, Opscode, Inc
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

default[:chef_rvm][:umask]      = "0022"
default[:chef_rvm][:url_type]   = "http"

default[:chef_rvm][:path]       = "/var/lib/chef"
default[:chef_rvm][:serve_path] = "/var/lib/chef"
default[:chef_rvm][:run_path]   = "/var/run/chef"
default[:chef_rvm][:cache_path] = "/var/cache/chef"
default[:chef_rvm][:backup_path] = "/var/lib/chef/backup"

default[:chef_rvm][:server_version]  = node.chef_packages.chef[:version]
default[:chef_rvm][:client_version]  = node.chef_packages.chef[:version]
default[:chef_rvm][:client_interval] = "1800"
default[:chef_rvm][:client_splay]    = "20"
default[:chef_rvm][:log_dir]         = "/var/log/chef"
default[:chef_rvm][:server_port]     = "4000"
default[:chef_rvm][:webui_port]      = "4040"
default[:chef_rvm][:webui_enabled]   = false
default[:chef_rvm][:solr_heap_size]  = "256M"
default[:chef_rvm][:validation_client_name] = "chef-validator"

default[:chef_rvm][:server_fqdn]     = node.has_key?(:domain) ? "chef.#{domain}" : "chef"
default[:chef_rvm][:server_url]      = "#{node.chef_rvm.url_type}://#{node.chef_rvm.server_fqdn}:#{node.chef_rvm.server_port}"

default[:chef_rvm][:rvm_ruby] = "1.9.2-p180@chef"
default[:chef_rvm][:rvm_binary] = "/usr/bin/rvm"
