class drupalstack::drupalapp {
  file { '/var/www/drupal/sites/default/settings.php':
    ensure  => present,
    mode   => '777',
    source  => 'file:///var/www/drupal/sites/default/default.settings.php',
  }

  file { '/var/www/drupal/sites/default/files':
    ensure => directory,
    mode   => '777',
  }
}