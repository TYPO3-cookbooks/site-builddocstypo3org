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

######################################
# Create User and directories
######################################

owner = docs_application_owner
owner_home = docs_user_home
www_group = docs_www_group

user owner do
  comment "User for build.docs.typo3.org Virtual Host"
  shell "/bin/bash"
  home owner_home
  supports :manage_home=>true
end

directory owner_home do
  owner owner
  group owner
  mode "0755"
  recursive true
  action :create
end


# @todo investigate whether it should go into apache2.rb
# Make sure the user is part of www-data group for write permission
group www_group  do
  action :modify
  members owner
  append true
end

# Add some git default shortcut for convenience sake
template "#{owner_home}/.gitconfig" do
  path "#{owner_home}/.gitconfig"
  source "gitconfig.erb"
  owner "#{owner}"
  group "#{owner}"
end
