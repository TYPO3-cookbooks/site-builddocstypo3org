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

# we must run python and git default recipes to be sure we have git and python_pip available
include_recipe "python"
include_recipe "git"
include_recipe "mercurial"

home = docs_base_directory
owner = docs_application_owner
www_group = docs_www_group

# setuptools 10.0.1 is broken: https://bitbucket.org/pypa/setuptools/issue/320
python_pip "setuptools" do
  version "9.1"
  action :install
end

# Install python packages
%w{sphinx PyYAML docutils pygments}.each do |package|
  python_pip "#{package}" do
    action :install
  end
end

# Create directory for Sphinx contrib
directory "#{home}/Sphinx-Contrib" do
  owner "#{home}/Sphinx-Contrib"
  group "#{www_group}"
  mode "0755"
  recursive true
  action :create
end

# Clone Sphinx-Contrib
mercurial "#{home}/Sphinx-Contrib" do
  repository "https://bitbucket.org/xperseguers/sphinx-contrib"
  reference "tip"
  action :sync
end

# Install 3rd-party Sphinx extensions
%w{googlechart googlemaps httpdomain numfig slide youtube}.each do |extension|
  bash "Installing 3rd-party extension #{extension}" do
    user "root"
    cwd "#{home}/Sphinx-Contrib/#{extension}"
    code <<-EOH
    python setup.py install
    EOH
  end
end

# Create directory for Rest Tool
directory "#{home}/RestTools" do
  owner "#{owner}"
  group "#{www_group}"
  mode "0755"
  recursive true
  action :create
end

# Clone reST tools for TYPO3.
git "#{home}/RestTools" do
  user "#{owner}"
  group "#{www_group}"
  repository "git://git.typo3.org/Documentation/RestTools.git"
  action :sync
end

# ... install TYPO3 theme (t3sphinx)
bash "install_t3sphinx" do
  user "root"
  cwd "#{home}/RestTools/ExtendingSphinxForTYPO3"
  code <<-EOH
  python setup.py install
  EOH
end

# ... and convert the Share font
bash "convert_sharefont" do
  user "root"
  cwd "#{home}/RestTools/LaTeX/font"
  code <<-EOH
  ./convert-share.sh
  EOH
end
