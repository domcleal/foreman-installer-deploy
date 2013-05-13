class fmnet::puppetdb {
  Postgresql_psql {
    cwd => "/",
  }

  postgresql::db { 'puppetdb':
    user     => 'puppetdb',
    password => 'puppetdb',
    grant    => 'all',
    before   => Class['puppetdb::server'],
    require  => Class['::postgresql::server'],
  }
}
