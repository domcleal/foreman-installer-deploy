class squid::filesystem {
  mounttab { "/var/spool/squid":
    ensure   => present,
    device   => "LABEL=squidcache",
    fstype   => "auto",
    options  => "defaults",
    dump     => "1",
    pass     => "2",
    provider => augeas,
    notify   => Exec["mount-squid"],
  }

  exec { "mount-squid":
    command     => "/bin/mount /var/spool/squid",
    refreshonly => true,
  }

  file { "/var/spool/squid":
    mode    => 0750,
    owner   => squid,
    group   => squid,
    require => Exec["mount-squid"],
  }

  # Nov 27 10:05:50 foreman puppet-master[4447]: Could not autoload mountpoint: undefined method `downcase' for nil:NilClass at /etc/puppet/modules/production/squid/manifests/filesystem.pp:15 on node foreman.fm.example.net
  #mountpoint { '/var/spool/squid':
  #  ensure  => present,
  #  require => Mounttab['/var/spool/squid'],
  #}
}
