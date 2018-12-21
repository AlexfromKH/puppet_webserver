class webserver (
  $packagename   = $webserver::parameters::packagename,
  $configfile    = $webserver::parameters::configfile,
  $configsource  = $webserver::parameters::configsource,
  $vhostfile     = $webserver::parameters::vhostfile,
  ) inherits webserver::parameters
  {
  package { 'webserver-package':
    ensure      => present,
    name        => $packagename,
  }

  file { 'config-file':
    ensure      => file,
    path        => $configfile,
    source      => $configsource,
    require     => Package['webserver-package'],
    notify      => Service['webserver-service'],
  }

  file { 'vhost-file':
    ensure      => file,
    path        => $vhostfile,
    content     => template('webserver/vhost.conf.erb'),
    require     => Package['webserver-package'],
    notify      => Service['webserver-service'],
  }

  service { 'webserver-service':
    name        => $packagename,
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    require     => [ File['config-file'], File['vhost-file'] ],
    subscribe      => [ File['config-file'], File['vhost-file'] ],

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
