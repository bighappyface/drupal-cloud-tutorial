class drupalstack::drupalapp {
  file { '/var/www/drupal/sites/default':
    ensure => directory,
    mode   => 'a+w',
    before => File['/var/www/drupal/sites/default'],
  }

  file { '/var/www/drupal/sites/default':
    ensure => directory,
    mode   => 'a+w',
    before => File['/var/www/drupal/sites/default/settings.php'],
  }

  file { '/var/www/drupal/sites/default/settings.php':
    ensure => present,
    source => 'file:///var/www/drupal/sites/default/default.settings.php',
    mode   => 'a+w',
  }
}