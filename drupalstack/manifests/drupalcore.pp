class drupalstack::drupalcore {
  $drupal_version = '7.18'

  file { '/opt/DrupalCore': ensure => directory, }

  exec { 'get-drupal':
    command => "wget http://ftp.drupal.org/files/projects/drupal-${drupal_version}.tar.gz -P /opt/DrupalCore",
    path    => ['/usr/bin'],
    creates => "/opt/DrupalCore/drupal-${drupal_version}.tar.gz",
    require => File['/opt/DrupalCore'],
  }

  exec { 'uncompress-drupal':
    command => "tar -xzf /opt/DrupalCore/drupal-${drupal_version}.tar.gz -C /opt/DrupalCore",
    path    => ['/bin'],
    creates => "/opt/DrupalCore/drupal-${drupal_version}",
    require => Exec['get-drupal'],
  }

  file { '/opt/DrupalCore/current':
    ensure  => link,
    target  => "/opt/DrupalCore/drupal-${drupal_version}",
    require => Exec['uncompress-drupal']
  }
}