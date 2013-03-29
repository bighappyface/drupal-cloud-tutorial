class drupalstack::varnish {
  exec { 'setup-varnish-repo':
    command => 'rpm -Uvh http://repo.varnish-cache.org/redhat/varnish-3.0/el5/noarch/varnish-release-3.0-1.noarch.rpm',
    path    => ['/bin'],
    creates => '/usr/sbin/varnishd',
  }

  package { 'varnish':
    ensure  => present,
    require => Exec['setup-varnish-repo'],
  }

  file { 'varnish-vcl':
    path    => '/etc/varnish/default.vcl',
    source  => 'puppet:///modules/drupalstack/varnish',
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