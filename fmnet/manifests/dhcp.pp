class fmnet::dhcp {
  # Static hosts
  dhcp::host { "foreman.fm.example.net":
    mac     => "52:54:00:56:d6:95",
    ip      => "192.168.101.10",
    comment => "Primary Foreman instance",
  }
}
