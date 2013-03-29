class drupalstack::php {
  package { ['php5', 'php5-mysql', 'libapache2-mod-php5']: ensure => present, }
}