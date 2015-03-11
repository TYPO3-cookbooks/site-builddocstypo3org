#
# Cookbook Name:: site-builddocstypo3org
#
# Copyright 2012, TYPO3 Association
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

# This recipe gets a few things ready for the app deployed by Surf
# (or by rsync in development vagrant).
# Notes:
# - The app itself does not depend on python, so python is handled in
#   the _restructuredtext recipe.
# - The app needs php, but that should be handled by the _php5 recipe.
#
# Surf will need php, git, and possibly composer.
include_recipe "git"
include_recipe "composer"

######################################
# Create User and directories
######################################

# Application variables
owner = docs_application_owner
home = docs_base_directory #/var/www/vhosts/<site>
deploy_to = docs_deploy_directory #<home>/releases
shared_to = docs_shared_directory #<home>/shared
document_root = docs_document_root_directory #<deploy_to>/current

# Database
database = node['site-builddocstypo3org']['database']['name']
username = node['site-builddocstypo3org']['database']['username']
password = node['site-builddocstypo3org']['database']['password']
hostname = node['site-builddocstypo3org']['database']['hostname']

# Create home directory
directory deploy_to do
  owner owner
  group owner
  mode "0755"
  recursive true
  action :create
end

# Fetch the default context
default_context = node['site-builddocstypo3org']['app']['context']

# Write Settings.yaml file for different contexts
contexts = %W[ Production Development ]
contexts.each do |context|

  # Create shared configuration
  %W[ / /Configuration /Configuration/#{context} ].each do |path|

    directory "#{shared_to}#{path}" do
      owner owner
      group owner
      mode "0755"
      #recursive true
      action :create
    end

  end

  template "#{shared_to}/Configuration/#{context}/Settings.yaml" do
    source "flow/settings.yaml.erb"
    owner owner
    group owner
    mode "0644"
    variables(
      :database => database,
      :user => username,
      :password => password,
      :host => hostname
    )
  end
end

# Set profile file where global environment variables are defined
# Notice, it can be a bit dangerous to simply override the file which could evolve with the distrib...
# @todo put this at the level of the user.
#template "/etc/profile" do
#  source "profile"
#end

######################################
#t3xutils.phar
######################################

t3xutils_cache_dir = "#{Chef::Config[:file_cache_path]}/t3xutils"

directory t3xutils_cache_dir do
  action :create
end

t3xutils_cache_file = "#{t3xutils_cache_dir}/t3xutils.phar"
t3xutils_phar_file = "/usr/local/bin/t3xutils.phar"

remote_file t3xutils_cache_file do
  source "http://bit.ly/t3xutils"
  mode "0755"
  action :create
  not_if do
    ::File.exist?(t3xutils_cache_file)
  end
end

link t3xutils_phar_file do
  to t3xutils_cache_file
end
