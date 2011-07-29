#
# Modified By:: Matthew Kent
# Original Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: chef-server
# Attributes:: default
#
# Copyright 2008-2011, Opscode, Inc
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

default['chef_server']['umask']           = "0022"
default['chef_server']['log_dir']         = "/var/log/chef"
default["chef_server"]["conf_dir"]        = "/etc/chef"
default['chef_server']['url']             = "http://localhost:4000"
default['chef_server']['api_port']        = "4000"
default['chef_server']['webui_port']      = "4040"
default['chef_server']['webui_enabled']   = false
default['chef_server']['solr_heap_size']  = "256M"
default['chef_server']['expander_nodes']  = 1
default['chef_server']['expander_index']  = 1
default['chef_server']['validation_client_name'] = "chef-validator"

default["chef_server"]["init_style"]  = "init"
default["chef_server"]["run_path"]    = "/var/run/chef"
default["chef_server"]["cache_path"]  = "/var/cache/chef"
default["chef_server"]["backup_path"] = "/var/lib/chef/backup"

default["chef_server"]["path"]        = "/var/lib/chef"