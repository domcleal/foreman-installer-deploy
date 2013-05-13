class fmnet::dns {
  concat_fragment { "dns_zones+20_ipa_delegation.dns":
    content => template('fmnet/ipa_delegation.zone.erb'),
  }
}
