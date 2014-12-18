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

###################################################
# Install PHP and PHP-FPM (FastCGI Process Manager)
###################################################
include_recipe "php"
include_recipe "php::fpm"

###################################################
# PHP FPM Configuration
###################################################
user = docs_application_owner
www_group = docs_www_group
server_name = docs_server_name
log_directory = docs_log_directory
fpm_port = docs_fpm_port

###################################################
# PHP FPM Environment Setup
###################################################

template "/etc/php5/fpm/pool.d/#{server_name}.conf" do
  source "php/php-fpm-site-template.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
	:pool_name => server_name.gsub(".", ""),
	:log_dir => log_directory,
	:fpm_port => fpm_port,
	:user => user,
	:group => www_group
  )
  notifies :restart, 'service[php5-fpm]'
end

#start up php-fpm
service "php5-fpm" do
  supports :restart => true
  action [ :enable, :start ]
end
