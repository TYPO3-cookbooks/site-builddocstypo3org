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
# Install system packages
######################################

# NOTE: Don't install python packages through apt (except python-pygraphviz).
# Instead, let the packages install with pip/setuptools retrieved by the
# python recipe, which will choose the best method.
#
# setuptools is under active development, regularly releasing new versions,
# and some of those new versions conflict with system packages causing
# random failures. The python recipe takes care of this, installing python
# through apt, and the rest through pip (or whatever is best).
#
# One exception to this rule is python-pygraphviz because pip can't find
# the graphviz libs otherwise. (ugh)

packages = %w{
	tidy
	acl
	zip
	graphicsmagick

	graphviz
	python-pygraphviz

	php5-mysqlnd
	php5-curl
	php5-gd
	php5-adodb
	php5-mcrypt
	php5-sqlite
	php5-xsl
	php5-ldap

	php5-fpm

}.each do |pkg|
    package pkg do
      action :install
    end
end
	
# Only install TextLive is configured so, default is true.
if node['site-builddocstypo3org']['install']['texlive']

  packages = %w{
    texlive
    texlive-base
    texlive-latex-extra
    texlive-fonts-extra
  }.each do |pkg|
      package pkg do
        action :install
      end
  end
end
