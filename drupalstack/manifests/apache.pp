class drupalstack::apache {
  package { 'apache2': ensure => present, }

  file { 'drupal.conf':
    path    => '/etc/apache2/sites-available/default',
    source  => 'puppet:///modules/drupalstack/drupal.conf',
    ensure  => present,
    require => Package['apache2'],
    notify  => Service['apache2-service'],
  }

  service { 'apache2-service':
    name       => 'apache2',
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  exec { '/usr/sbin/a2enmod rewrite':
    unless => '/bin/readlink -e /etc/apache2/mods-enabled/rewrite.load',
    notify => Service['apache2-service'],
  }
}