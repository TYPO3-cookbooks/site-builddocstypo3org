name "site-builddocstypo3org"
maintainer       "TYPO3 Association"
maintainer_email "fabien.udriot@typo3.org"
license          "Apache 2.0"
description      "Installs/Configures docs.typo3.org"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.6.1"

depends          "t3-base",     "~> 0.2.0"


depends          "t3-mysql",    "~> 0.1.3"
#_php5
# this is monkey-patched version
depends          "php",         "= 1.1.2"


#_nginx
depends          "nginx",       "= 1.6.0"
#_mysql
depends          "database",    "= 1.3.12"
#_app
depends          "composer",    "= 1.0.6"
#_app _restructuredtext
depends          "git"          # pinned in t3-base
#_restructuredtext
depends          "python",      "= 1.4.6"
depends          "mercurial",   "= 2.0.4"
#dev_vagrant (for dev vagrant box)
depends          "rabbitmq",    "= 2.3.2"
