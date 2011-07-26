#
# Modified By:: Matthew Kent
# Original Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: couchdb
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc
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

include_recipe "erlang"

package "couchdb" do
  action :install 
end

directory "/var/lib/couchdb" do
  owner "couchdb"
  group "couchdb"
  recursive true
  path "/var/lib/couchdb"
end

service "couchdb" do
  start_command "/sbin/service couchdb start &> /dev/null"
  stop_command "/sbin/service couchdb stop &> /dev/null"
  supports [ :restart, :status ]
  action [ :enable, :start ]
end
