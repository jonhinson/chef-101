#
# Cookbook Name:: applications
# Recipe:: default
#
# Copyright 2009, Engine Yard, Inc.
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

directory "/var/www" do
  owner node[:user]
  mode 0755
end

node[:apps].each do |app|
  
  cap_directories = [
    "/var/www/#{app[:name]}/shared",
    "/var/www/#{app[:name]}/shared/config",
    "/var/www/#{app[:name]}/shared/system",
    "/var/www/#{app[:name]}/releases",
    "/var/www/#{app[:name]}/current"
  ]
  
  cap_directories.each do |dir|
    directory dir do
      owner node[:user]
      mode 0755
      recursive true
    end
  end
  
  template "#{node[:nginx][:dir]}/sites-available/#{app[:name]}" do
    source "app.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :app => app
    })
  end

  link "#{node[:nginx][:dir]}/sites-enabled/#{app[:name]}" do
    to "#{node[:nginx][:dir]}/sites-available/#{app[:name]}"
    link_type :symbolic
  end
  
end

