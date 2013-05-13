class fmnet::autofs {
  file { "/nfs":
    ensure => directory,
  }

  file { "/etc/auto.master":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0644,
    source => "puppet:///modules/fmnet/auto.master",
  }

  file { "/etc/auto.nfs":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0644,
    source => "puppet:///modules/fmnet/auto.nfs",
    notify => Service["autofs"],
  }

  package { ["autofs", "nfs-utils"]:
    ensure => present,
  }

  service { "autofs":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => [
      Package["autofs", "nfs-utils"],
      File["/nfs", "/etc/auto.master", "/etc/auto.nfs"],
    ],
  }
}
