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

# This recipe depends on
# - python & pip (installed w/ python)
# - git
# - mercurial
# It also expects graphviz to be installed (in the _packages recipe)
# Also, make sure _packages does not install pip or setuptools!
include_recipe "python"
include_recipe "git"
include_recipe "mercurial"

home = docs_base_directory
owner = docs_application_owner
www_group = docs_www_group

# Install python packages
%w{
	sphinx
	PyYAML
	Pillow
	docutils
	Pygments
	t3fieldlisttable
	t3tablerows
	t3targets
	sphinxcontrib-googlechart
	sphinxcontrib-httpdomain
	sphinxcontrib-slide
	sphinx_numfig
	sphinxcontrib-actdiag
	sphinxcontrib-blockdiag
	sphinxcontrib-seqdiag
	sphinxcontrib-nwdiag
	sphinxcontrib-phpdomain
}.each do |package|
  python_pip "#{package}" do
    action :install
  end
end

# Most Sphinx-contrib's can be installed with pip (above),
# but for any that we make changes to, we use xperseguers fork.
# Currently, that includes 
#  - googlemaps: where we want English instead of Japanese.
#  - youtube: Which is NOT the same as sphinxcontrib.youtube on pypi

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
%w{googlemaps youtube}.each do |extension|
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
