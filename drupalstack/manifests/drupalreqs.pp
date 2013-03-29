class drupalstack::drupalreqs {
  file { '/var/www/drupal/sites/default':
    ensure => directory,
    mode   => 'a+w',
  }

  file { '/var/www/drupal/sites/default/settings.php':
    ensure => present,
    source => 'file:///var/www/drupal/sites/default/default.settings.php',
    mode   => 'a+w',
  }
}