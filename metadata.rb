name "site-builddocstypo3org"
maintainer       "TYPO3 Association"
maintainer_email "fabien.udriot@typo3.org"
license          "Apache 2.0"
description      "Installs/Configures docs.typo3.org"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.3.0"

depends "apt", '~> 2.3.0'
depends "composer", '~> 1.0.5'
depends "database", '= 1.3.12'
depends "mysql", '= 1.3.0'
depends "php"
depends "git", '= 0.9.0'
depends "apache2", '~> 1.11.0'
depends "python", '~> 1.4.6'
depends "mercurial", '~> 2.0.4'
