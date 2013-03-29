class drupalstack::php {
  package { ['php5', 'php-mysql', 'libapache2-mod-php']: ensure => present, }
}