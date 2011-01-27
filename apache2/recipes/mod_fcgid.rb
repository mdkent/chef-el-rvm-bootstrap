#
# Modified By:: Matthew Kent
# Original Author:: Opscode, Inc.
# Cookbook Name:: apache2
# Recipe:: fcgid 
#
# Copyright 2008-2009, Opscode, Inc.
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

package "mod_fcgid" do
  notifies :run, resources(:execute => "generate-module-list"), :immediately
end

file "#{node[:apache][:dir]}/conf.d/fcgid.conf" do
  action :delete
  backup false 
end

apache_module "fcgid" do
  conf true
end
