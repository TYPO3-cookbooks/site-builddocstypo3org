#
# Cookbook Name:: site-builddocstypo3org
# Recipe:: default
#
# Copyright 2012, TYPO3 Association
#
# Licensed under the Apache License, Version 2.0 (the"site-builddocstypo3org::License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an"site-builddocstypo3org::AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

############################################################################
# This recipe should only be used in the Dev Environment (the Vagrant Box) #
############################################################################
# Note: The Production Berksfile does *not* include the rabbitmq recipe,
# so this recipe *will* break if used in production.

# Include Helper function
::Chef::Recipe.send(:include, TYPO3::Docs)

# Install the RabbitMQ Server in the dev vagrant box
# The client libs are in php, and should not be installed by chef.
include_recipe "rabbitmq::default"
include_recipe "rabbitmq::plugin_management"
include_recipe "rabbitmq::user_management"
include_recipe "rabbitmq::mgmt_console"

#link the shared configuration in the dev box.
#This should be done by Surf on production
shared_directory = docs_shared_directory
flow_root = docs_document_root_directory
owner = docs_application_owner
www_group = docs_www_group

contexts = %W[ Production Development ]
contexts.each do |context|

  # If the directory has already been created, drop it.
  directory "#{flow_root}/Configuration/#{context}" do
    recursive true
    action :delete
  end

  # Create links to shared configuration
  link "#{flow_root}/Configuration/#{context}" do
    to "#{shared_directory}/Configuration/#{context}"
    owner owner
    group www_group
  end
 
  # If the directory has already been created, drop it.
  directory "#{flow_root}/Configuration/#{context}/Vagrant" do
    action :create
    owner owner
    group www_group
    mode "0755"
  end

  # This makes Development/Vagrant use the same settings as Development context.
  link "#{shared_directory}/Configuration/#{context}/Vagrant/Settings.yaml" do
    to "#{shared_directory}/Configuration/#{context}/Settings.yaml"
    owner owner
    group www_group
  end

end
