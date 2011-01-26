#
# Modified By:: Matthew Kent
# Original Author:: Opscode, Inc.
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2008-2010, Opscode, Inc.
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

# force ohai to run and pick up new languages.java data
ruby_block "reload_ohai" do
  block do
    o = Ohai::System.new
    o.all_plugins
    node.automatic_attrs.merge! o.data
  end
  action :nothing
end

package "java-1.6.0-openjdk" do
  action :install
  notifies :create, resources(:ruby_block => "reload_ohai"), :immediately
end

package "java-1.6.0-openjdk-devel" do
  action :install
end
