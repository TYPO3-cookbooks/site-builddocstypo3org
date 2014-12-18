#
# Cookbook Name:: site-builddocstypo3org
#
# Copyright 2014, TYPO3 Association
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

######################################
# Install nginx
######################################
include_recipe "nginx::default"

######################################
# Configure Virtual Host
######################################
user = docs_application_owner
www_group = docs_www_group
server_name = docs_server_name
document_root = docs_web_directory
log_directory = docs_log_directory
flow_rootpath = docs_document_root_directory
flow_context = node['site-builddocstypo3org']['app']['context']
fpm_port = docs_fpm_port


######################################
# Configure nginx Environment
######################################
directories = [log_directory, document_root]
directories.each do |directory|
  directory "#{directory}" do
    owner user
    group www_group
    mode "0755"
    recursive true
    action :create
  end
end

cookbook_file "/etc/nginx/flow.conf" do
  source "nginx/flow.conf"
end

template "/etc/nginx/sites-available/#{server_name}" do
  source "nginx/nginx-site.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :log_dir => log_directory,
	:document_root => document_root,
	:server_name => server_name,
	:fpm_port => fpm_port,
	:flow_context => flow_context,
	:flow_rootpath => flow_rootpath
  )
  notifies :reload, "service[nginx]"
end

nginx_site server_name do
  enable true
end

#Get rid of the default site
nginx_site 'default' do
  enable false
end
