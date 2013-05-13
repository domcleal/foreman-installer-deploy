class fmnet::squid {
  $proxy = "http://foreman.fm.example.net:3128"

  case $::operatingsystem {
    Fedora,RedHat: {
      augeas { "yum-proxy":
        context => "/files/etc/yum.conf",
        changes => "set main/proxy ${proxy}",
      }
    }
    default: { }
  }

  file { "/etc/profile.d/proxy.sh":
    mode    => 755,
    content => "export http_proxy=${proxy}\n",
  }
}
