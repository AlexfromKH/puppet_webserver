class puppet_webserver (
  $ensure         = 'absent',
  $ensure_service = 'stopped',
  $ensure_file    = 'absent',
  # cpecial parameters
  $packagename    = $webserver::parameters::packagename,
  $configfile     = $webserver::parameters::configfile,
  $configsource   = $webserver::parameters::configsource,
  $vhostfile      = $webserver::parameters::vhostfile,
  ) inherits ::webserver::parameters
  {
  package { 'webserver-package':
    ensure      => $ensure,
    name        => $packagename,
  }

  file { 'config-file':
    ensure      => $ensure_file,
    path        => $configfile,
    source      => $configsource,
    require     => Package['webserver-package'],
    notify      => Service['webserver-service'],
  }

  file { 'vhost-file':
    ensure      => $ensure_file,
    path        => $vhostfile,
    content     => template('webserver/vhost.conf.erb'),
    require     => Package['webserver-package'],
    notify      => Service['webserver-service'],
  }

  service { 'webserver-service':
    name        => $packagename,
    ensure      => $ensure_service,
    enable      => true,
    hasrestart  => true,
    require     => [ File['config-file'], File['vhost-file'] ],

  }
}
#       if $::osfamily == 'RedHat' {
#               package { 'httpd':
#                       ensure => present
#               }
#       } elsif $::osfamily == 'Debian' {
#               package { 'apache2':
#                       ensure => present
#               }
#       }
#}
