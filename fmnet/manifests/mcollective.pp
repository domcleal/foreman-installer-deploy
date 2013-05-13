class fmnet::mcollective {
  file{ "/etc/mcollective/facts.yaml":
    owner    => root,
    group    => root,
    mode     => 400,
    loglevel => debug,
    content  => inline_template("<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime_seconds|timestamp|free)/ }.to_yaml %>"),
    require  => Class['::mcollective'],
  }

  mcollective::plugins::plugin { 'puppetd':
    ensure        => file,
    type          => 'agent',
    ddl           => true,
    application   => true,
    module_source => 'puppet:///modules/fmnet/plugins/puppetd',
  }

  mcollective::plugins::plugin { 'augeasquery':
    ensure        => file,
    type          => 'agent',
    ddl           => true,
    module_source => 'puppet:///modules/fmnet/plugins/augeasquery',
  }

  file { "/usr/libexec/mcollective/mcollective/application/augeas.rb":
    ensure => $ensure,
    source => "puppet:///modules/fmnet/plugins/augeasquery/application/augeas.rb",
  }
}
