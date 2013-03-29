class drupalstack::varnish {
  package { 'varnish': ensure => present, }

  file { 'varnish-vcl':
    path    => '/etc/varnish/default.vcl',
    source  => 'puppet:///modules/drupalstack/default.vcl',
    ensure  => present,
    require => Package['varnish'],
  }

  service { 'varnish-service':
    name       => 'varnish',
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => File['varnish-vcl'],
  }
}