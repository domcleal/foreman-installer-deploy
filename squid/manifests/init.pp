class squid {
  package { 'squid':
    ensure => present,
  }

  service { 'squid':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['squid']
  }

  include squid::filesystem

  file { '/etc/squid/squid.conf':
    ensure  => present,
    source  => 'puppet:///modules/squid/squid.conf',
    notify  => Service['squid'],
    require => Class['squid::filesystem'],
  }
}
