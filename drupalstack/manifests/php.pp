class drupalstack::php {
  package { ['php5', 'php5-mysql', 'php5-gd', 'libapache2-mod-php5']: ensure => present, }
}