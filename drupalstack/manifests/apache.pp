class drupalstack::apache {
  package { 'httpd': ensure => present, }

  file { 'drupal.conf':
    path    => '/etc/httpd/conf.d/drupal.conf',
    source  => 'puppet:///modules/drupalstack/drupal.conf',
    ensure  => present,
    require => Package['varnish'],
  }

  service { 'apache':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => File['drupal.conf'],
  }
}