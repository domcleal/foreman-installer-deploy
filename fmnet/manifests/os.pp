class fmnet::os {
  kernel_parameter { ["quiet", "rhgb"]:
    ensure => absent,
  }

  kernel_parameter { "elevator":
    ensure => present,
    value  => "noop",
  }
}
