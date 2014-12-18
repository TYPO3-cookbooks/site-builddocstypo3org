name "site-builddocstypo3org"
maintainer       "TYPO3 Association"
maintainer_email "fabien.udriot@typo3.org"
license          "Apache 2.0"
description      "Installs/Configures docs.typo3.org"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.3.2"

#_packages
depends "apt", '~> 2.3.0'

#_php5
depends "php", '~> 1.1.0'

#_nginx
depends "nginx", '~> 1.6.0'

#_mysql
depends "mysql", '= 1.3.0'
depends "database", '= 1.3.12'

#_app
depends "composer", '~> 1.0.5'

#_app _restructuredtext
depends "python", '~> 1.4.6'
depends "git", '= 0.9.0'

#_restructuredtext
depends "mercurial", '~> 2.0.4'
