class drupalstack::drupalapp {
  file { '/var/www/drupal':
    ensure  => directory,
    source  => 'puppet:///modules/drupalstack/drupal',
    recurse => true,
    links   => manage,
    before  => File['/var/www/drupal/sites/default/settings.php'],
  }

  file { '/var/www/drupal/sites/default/settings.php':
    ensure => present,
    source => 'file:///var/www/drupal/sites/default/default.settings.php',
    before => File['/var/www/drupal/sites/default'],
  }

  file { '/var/www/drupal/sites/default':
    ensure  => directory,
    mode    => '664',
    recurse => true,
  }
}